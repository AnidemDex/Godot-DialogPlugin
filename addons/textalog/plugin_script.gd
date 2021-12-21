tool
extends EditorPlugin

const PLUGIN_NAME = "Textalog"

# Hardcoded paths because is not a good idea to rely on
# scanning directories for now

var event_scripts := PoolStringArray([
	"res://addons/textalog/events/dialog/text.gd",
	"res://addons/textalog/events/dialog/choice.gd",
	"res://addons/textalog/events/character/change_expression.gd",
	"res://addons/textalog/events/character/join.gd",
	"res://addons/textalog/events/character/leave.gd",
])

var _welcome_scene:PackedScene = load("res://addons/textalog/nodes/editor/welcome/hi.tscn")

var _plugin_data := ConfigFile.new()
var _version_button:BaseButton

var inspector_plugin_path:String = "res://addons/textalog/events/inspector.gd"
var inspector_plugin:EditorInspectorPlugin


func get_plugin_data(data:String) -> String:
	var info = _plugin_data.get_value("plugin",data, "???")
	return info


func get_plugin_version() -> String:
	return get_plugin_data("version")


func get_event_system_plugin() -> EditorPlugin:
	var editor_interface:EditorInterface = get_editor_interface()
	var event_system:EditorPlugin = null
	
	if get_tree().has_meta("EventSystem"):
		# Mira si existe el "singleton"
		event_system = get_tree().get_meta("EventSystem") as EditorPlugin
	else:
		# Sino, buscalo manualmente
		event_system = editor_interface.get_parent().get_node_or_null("Event System") as EditorPlugin
	
	return event_system


func is_event_system_enabled() -> bool:
	var editor_interface:EditorInterface = get_editor_interface()
	var event_system = get_event_system_plugin()
	var enabled = false
	
	
	if is_instance_valid(event_system):
		enabled = true
	else:
		# Finalmente, pregunta al editor, aunque llegados a este punto algo puede que este mal
		enabled = editor_interface.is_plugin_enabled("event_system_plugin")
		
	return enabled


func enable_event_system() -> void:
	var editor_interface:EditorInterface = get_editor_interface()
	editor_interface.set_plugin_enabled("event_system_plugin", true)
	
	var path = "res://addons/textalog/events/"
	var file = ".gdignore"
	
	if is_event_system_enabled():
		var dir := Directory.new()
		if dir.file_exists(path+file):
			dir.remove(path+file)
		
		call_deferred("_remove_inspector_events")
		call_deferred("_add_inspector_events")
		call_deferred("_add_events_to_event_system")
	else:
		var _file := File.new()
		_file.open(path+file,File.WRITE)
		_file.close()
		
	_force_rescan()


func _add_itself_to_editor_meta() -> void:
	get_tree().set_meta("Textalog", self)


func _add_inspector_events() -> void:
	# if event system enabled
	if not is_event_system_enabled():
		push_warning("Event system is not enabled")
		return
	
	if not ResourceLoader.exists(inspector_plugin_path):
		return
	
	if inspector_plugin != null:
		return
	
	inspector_plugin = load(inspector_plugin_path).new()
	inspector_plugin.set("plugin_script", self)
	inspector_plugin.set("editor_inspector", get_editor_interface().get_inspector())
	inspector_plugin.set("editor_gui", get_editor_interface().get_base_control())
	add_inspector_plugin(inspector_plugin)


func _add_events_to_event_system() -> void:
	var event_system := get_event_system_plugin()
	if is_instance_valid(event_system):
		if event_system.has_method("register_event"):
			for event_script in event_scripts:
				var event = load(event_script)
				event_system.call("register_event", event)
		else:
			# If the event system has no register_event for some reason, do it manually
			var r_e_path := "res://addons/event_system_plugin/resources/registered_events/registered_events.tres"
			var registered_events:Resource = load(r_e_path)
			# shared array, be careful
			var events:Array = registered_events.get("events").duplicate()
			for event_script in event_scripts:
				var event = load(event_script)
				if not event in events:
					events.append(event)
			registered_events.set("events", events)
			var err = ResourceSaver.save(r_e_path, registered_events)
			if err != OK:
				push_error("There was an error while trying to register events: %s"%err)
			registered_events.emit_changed()


func _add_version_button() -> void:
	var _v = {"version":get_plugin_version()}
	
	_version_button = ToolButton.new()
	_version_button.connect("pressed", self, "_show_welcome")
	_version_button.text = "TaL:[{version}]".format(_v)
	_version_button.hint_tooltip = "Textalog version {version}".format(_v)
	
	connect("tree_exiting", _version_button, "free")
	
	var _new_color = _version_button.get_color("font_color")
	_new_color.a = 0.6
	_version_button.add_color_override("font_color", _new_color)
	_version_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	var _dummy := Control.new()
	var _dock_button := add_control_to_bottom_panel(_dummy, "dummy")
	_dock_button.get_parent().get_parent().add_child(_version_button)
	_dock_button.get_parent().get_parent().move_child(_version_button, 1)
	remove_control_from_bottom_panel(_dummy)
	_dummy.free()


func _remove_inspector_events() -> void:
	if inspector_plugin != null:
		remove_inspector_plugin(inspector_plugin)


func _remove_itself_from_editor_meta() -> void:
	get_tree().remove_meta("Textalog")


func _show_welcome() -> void:
	var _popup:Popup = _welcome_scene.instance() as Popup
	_popup.set("_textalog_plugin", self)
	_popup.set("_docs", get_plugin_data("docs"))
	_popup.set("_repo", get_plugin_data("repository"))
	_popup.set("_license", get_plugin_data("license"))
	_popup.set("_credits", get_plugin_data("credits"))
	_popup.connect("ready", _popup, "popup_centered_ratio", [0.4])
	_popup.connect("popup_hide", _popup, "queue_free")
	_popup.connect("hide", _popup, "queue_free")
	get_editor_interface().get_base_control().add_child(_popup)


func _force_rescan() -> void:
	var editor_interface:EditorInterface = get_editor_interface()
	editor_interface.get_resource_filesystem().call_deferred("scan")
	editor_interface.get_resource_filesystem().call_deferred("scan_sources")
	editor_interface.get_resource_filesystem().call_deferred("update_script_classes")


func _initialize() -> void:
	if is_event_system_enabled():
		_add_inspector_events()
		_add_events_to_event_system()
		_force_rescan()


func enable_plugin() -> void:
	_show_welcome()


func _enter_tree() -> void:
	_add_version_button()
	_add_itself_to_editor_meta()


func _ready() -> void:
	call_deferred("_initialize")


func _exit_tree() -> void:
	_remove_inspector_events()
	_remove_itself_from_editor_meta()


func _init() -> void:
	name = PLUGIN_NAME.capitalize()
	_plugin_data.load("res://addons/textalog/plugin.cfg")
