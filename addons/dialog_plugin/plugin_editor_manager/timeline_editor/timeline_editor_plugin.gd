tool
extends EditorPlugin

const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")
const PLUGIN_NAME = "Timeline Editor Manager"

var _timeline_editor_view:Control
var _dock_button:ToolButton

var _system_dock = get_editor_interface().get_file_system_dock()

func _init() -> void:
	name = PLUGIN_NAME


func _enter_tree() -> void:
	_system_dock.connect("file_removed", self, "_on_File_removed")
	
	_timeline_editor_view = load(DialogResources.TIMELINE_EDITOR_PATH).instance()
	_dock_button = add_control_to_bottom_panel(_timeline_editor_view, "TimelineEditor")
	_dock_button.visible = false


func handles(object: Object) -> bool:
	if object is DialogTimelineResource:
		return true
	return false


func edit(object: Object) -> void:
	var _db = load(DialogResources.TIMELINEDB_PATH)
	_db.add(object.resource_path)
	var _err = ResourceSaver.save(DialogResources.TIMELINEDB_PATH, _db)
	assert(_err == OK, "There was an error saving the timeline database: {0}".format([_err]))
	_timeline_editor_view.base_resource = object


func make_visible(visible: bool) -> void:
	if _dock_button and is_instance_valid(_dock_button):
		_dock_button.visible = visible
		_dock_button.pressed = visible


func _exit_tree() -> void:
	if _timeline_editor_view:
		remove_control_from_bottom_panel(_timeline_editor_view)
		_timeline_editor_view.free()


func _on_File_removed(file_path:String) -> void:
	var _db = load(DialogResources.TIMELINEDB_PATH)
	_db.remove(file_path)
	var _err = ResourceSaver.save(DialogResources.TIMELINEDB_PATH, _db)
	assert(_err == OK, "There was an error saving the timeline database: {0}".format([_err]))
