tool
extends EditorPlugin

const TimelineEditorView = preload("res://addons/dialog_plugin/Editor/Views/timeline_editor/timeline_editor_view.gd")
const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")
const PLUGIN_NAME = "Timeline Editor Manager"

var _timeline_editor_view:TimelineEditorView
var _dock_button:ToolButton


func _init() -> void:
	name = PLUGIN_NAME


func _enter_tree() -> void:
	_timeline_editor_view = load(DialogResources.TIMELINE_EDITOR_PATH).instance() as TimelineEditorView
	_dock_button = add_control_to_bottom_panel(_timeline_editor_view, "TimelineEditor")
	_dock_button.visible = false


func handles(object: Object) -> bool:
	if object is DialogTimelineResource:
		return true
	return false


func edit(object: Object) -> void:
	_timeline_editor_view.base_resource = object


func make_visible(visible: bool) -> void:
	if _dock_button and is_instance_valid(_dock_button):
		_dock_button.visible = visible
		_dock_button.pressed = visible


func save_external_data() -> void:
	_timeline_editor_view.save_resource()


func _exit_tree() -> void:
	if _timeline_editor_view:
		remove_control_from_bottom_panel(_timeline_editor_view)
		_timeline_editor_view.free()
