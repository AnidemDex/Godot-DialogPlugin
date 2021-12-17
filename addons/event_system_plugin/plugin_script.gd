tool
extends EditorPlugin

const PLUGIN_NAME = "EventSystem"
const _TimelineEditor = preload("res://addons/event_system_plugin/nodes/editor/timeline_editor/event_timeline_editor.gd")
const _EventManager = preload("res://addons/event_system_plugin/nodes/event_manager/event_manager.gd")
const _Timeline = preload("res://addons/event_system_plugin/resources/timeline_class/timeline_class.gd")
const _Event = preload("res://addons/event_system_plugin/resources/event_class/event_class.gd")

var _timeline_editor_scene:PackedScene = load("res://addons/event_system_plugin/nodes/editor/timeline_editor/event_timeline_editor.tscn") as PackedScene
var _registered_events:Resource = load("res://addons/event_system_plugin/resources/registered_events/registered_events.tres")
var _welcome_scene:PackedScene = load("res://addons/event_system_plugin/nodes/editor/welcome/hi.tscn")

var _timeline_editor:_TimelineEditor
var _dock_button:ToolButton
var _version_button:BaseButton

var _plugin_data:ConfigFile = ConfigFile.new()

var event_inspector:EditorInspectorPlugin


func _init() -> void:
	name = PLUGIN_NAME.capitalize()
	_plugin_data.load("res://addons/event_system_plugin/plugin.cfg")

func get_class(): return PLUGIN_NAME


func _enter_tree() -> void:
	_timeline_editor = _timeline_editor_scene.instance()
	_timeline_editor._UndoRedo = get_undo_redo()
	_timeline_editor._PluginScript = self
	_timeline_editor.connect("ready", _timeline_editor, "fake_ready")
	_timeline_editor.connect("event_selected", self, "_on_TimelineEditor_event_selected")
	connect("tree_exiting", _timeline_editor, "queue_free")
	
	_dock_button = add_control_to_bottom_panel(_timeline_editor, "TimelineEditor")
	_dock_button.visible = false
	_add_version_button()
	
	event_inspector = load("res://addons/event_system_plugin/core/event_inspector.gd").new()
	add_inspector_plugin(event_inspector)
	
	_add_itself_to_editor_meta()
	
	connect("scene_changed", self, "_on_scene_changed")


func enable_plugin() -> void:
	_show_welcome()


func handles(object: Object) -> bool:
	if object is _Event:
		return true
	
	if object is _Timeline:
		return true
	
	return false


func edit(object: Object) -> void:
	if object is _Event:
		return
	
	_timeline_editor.edit_resource(object)


func make_visible(visible: bool) -> void:
	if is_instance_valid(_dock_button):
		_dock_button.visible = visible
		_dock_button.pressed = visible


func save_external_data() -> void:
	if is_instance_valid(_timeline_editor):
		_timeline_editor.call_deferred("_update_values")


func register_event(event:Script) -> void:
	var events:Array = _registered_events.events.duplicate()
	if not event in events:
		events.append(event)
	_registered_events.set("events", events)
	var err = ResourceSaver.save(_registered_events.resource_path, _registered_events)
	if err != OK:
		push_error("There was an error while trying to register events: %s"%err)
	_registered_events.emit_changed()

func _exit_tree() -> void:
	if is_instance_valid(_timeline_editor):
		remove_control_from_bottom_panel(_timeline_editor)
		_timeline_editor.queue_free()
	remove_inspector_plugin(event_inspector)
	_remove_itself_from_editor_meta()


func _show_welcome() -> void:
	var _popup:Popup = _welcome_scene.instance() as Popup
	_popup.connect("ready", _popup, "popup_centered_ratio", [0.4])
	_popup.connect("popup_hide", _popup, "queue_free")
	_popup.connect("hide", _popup, "queue_free")
	get_editor_interface().get_base_control().add_child(_popup)


func _add_version_button() -> void:
	var _v = {"version":get_plugin_version()}
	
	_version_button = ToolButton.new()	
	_version_button.text = "ES:[{version}]".format(_v)
	_version_button.hint_tooltip = "EventSystem version {version}".format(_v)
	_version_button.connect("pressed", self, "_show_welcome")
	
	connect("tree_exiting", _version_button, "free")
	
	var _new_color = _version_button.get_color("font_color")
	_new_color.a = 0.6
	_version_button.add_color_override("font_color", _new_color)

	_dock_button.get_parent().get_parent().add_child(_version_button)
	_dock_button.get_parent().get_parent().move_child(_version_button, 1)


func _add_itself_to_editor_meta() -> void:
	get_tree().set_meta("EventSystem", self)


func _remove_itself_from_editor_meta() -> void:
	get_tree().remove_meta("EventSystem")


func get_plugin_version() -> String:
	var _version = _plugin_data.get_value("plugin","version", "0")
	return _version

var _last_selected_node:Control = null
func _on_TimelineEditor_event_selected(event:_Event) -> void:
	var _focus_owner = _timeline_editor.get_focus_owner()
	
	if _last_selected_node == _focus_owner:
		return

	_last_selected_node = _focus_owner
	get_editor_interface().inspect_object(event, "", true)
	_focus_owner.grab_focus()


func _on_RegisteredEvents_changed() -> void:
	print("Events changed")


func _on_TimelineEditor_preview_edit_pressed(resource) -> void:
	get_editor_interface().edit_resource(resource)


func _on_scene_changed(_scene_root:Node) -> void:
	if is_instance_valid(_timeline_editor):
		_timeline_editor._history.clear()
