tool
extends EditorPlugin

const PLUGIN_NAME = "Textalog"

var inspector_script_path := []

var _welcome_scene:PackedScene = load("res://addons/textalog/nodes/editor/welcome/hi.tscn")

var _plugin_data := ConfigFile.new()
var _version_button:BaseButton

var _inspectors := []


func get_plugin_data(data:String) -> String:
	var info = _plugin_data.get_value("plugin",data, "???")
	return info


func get_plugin_version() -> String:
	return get_plugin_data("version")


func is_event_system_enabled() -> bool:
	var editor_interface:EditorInterface = get_editor_interface()
	var event_system = null
	
	if get_tree().has_meta("EventSystem"):
		# Mira si existe el "singleton"
		event_system = get_tree().get_meta("EventSystem")
	else:
		# Sino, buscalo manualmente
		event_system = editor_interface.get_parent().get_node_or_null("Event System")
	return is_instance_valid(event_system)


func enable_event_system() -> void:
	if is_event_system_enabled():
		return
	var editor_interface:EditorInterface = get_editor_interface()
	editor_interface.set_plugin_enabled("event_system_plugin", true)
	
	var path = "res://addons/textalog/events/"
	var file = ".gdignore"
	if editor_interface.is_plugin_enabled("event_system_plugin"):
		var dir := Directory.new()
		if dir.file_exists(path+file):
			dir.remove(path+file)
	else:
		var _file := File.new()
		_file.open(path+file,File.WRITE)
		_file.close()
		
	
	call_deferred("_remove_inspector_events")
	call_deferred("_add_inspector_events")
	
	editor_interface.get_resource_filesystem().call_deferred("scan")
	editor_interface.get_resource_filesystem().call_deferred("scan_sources")
	editor_interface.get_resource_filesystem().call_deferred("update_script_classes")


func _add_itself_to_editor_meta() -> void:
	get_tree().set_meta("Textalog", self)


func _add_inspector_events() -> void:
	# if event system enabled
	if not get_editor_interface().is_plugin_enabled("event_system_plugin"):
		push_warning("Event system is not enabled")
		return
	for script_path in inspector_script_path:
		var inspector_plugin_script = load(script_path)
		var inspector_plugin:EditorInspectorPlugin = inspector_plugin_script.new()
		add_inspector_plugin(inspector_plugin)
		_inspectors.append(inspector_plugin)


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
	for inspector_plugin in _inspectors:
		remove_inspector_plugin(inspector_plugin)
	_inspectors = []


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


func enable_plugin() -> void:
	_show_welcome()


func _enter_tree() -> void:
	_add_version_button()
	_add_itself_to_editor_meta()


func _exit_tree() -> void:
	_remove_inspector_events()
	_remove_itself_from_editor_meta()


func _init() -> void:
	name = PLUGIN_NAME.capitalize()
	_plugin_data.load("res://addons/textalog/plugin.cfg")
