tool
extends EditorPlugin

const TimelineEditorView = preload("res://addons/dialog_plugin/Editor/Views/timeline_editor/timeline_editor_view.gd")
const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")
const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")
const PLUGIN_NAME = "Timeline Editor Manager"

var _timeline_editor_view:TimelineEditorView
var _dock_button:ToolButton

func get_class(): return "TimelineEditorManager"

func _init() -> void:
	name = PLUGIN_NAME


func _enter_tree() -> void:
	DialogUtil.Logger.print_debug(self, PLUGIN_NAME+" initialized.")
	add_events_to_settings()
	_timeline_editor_view = load(DialogResources.TIMELINE_EDITOR_PATH).instance() as TimelineEditorView
	_dock_button = add_control_to_bottom_panel(_timeline_editor_view, "TimelineEditor")
	_dock_button.visible = false

func add_events_to_settings() -> void:
	DialogUtil.Logger.print_debug(self, "Adding events to settings...")
	var globa_script_classes = ProjectSettings.get_setting("_global_script_classes")
	print(ClassDB.get_inheriters_from_class("DialogEventResource"))
	for script_class in globa_script_classes:
		var _base:String = script_class["base"]
		var _class:String = script_class["class"]
		var _lang:String = script_class["language"]
		var _path:String = script_class["path"]
		var _script = load(_path)
		
		if get_base_script_until_null(_script) == DialogEventResource:
			var setting_path:String = "textalog/events/{base}/{class}"
			if _base == "Resource":
				continue
			
			if _class in ["DialogCharacterEvent", "DialogMiscelaneousEvent", "DialogLogicEvent"]:
				continue

			if _base == "DialogEventResource":
				_base = _class
			
			_class = _class.replace("Dialog", "")
			_class = _class.replace("Event", "")
			_class = _class.capitalize()
			_class = _class.to_lower()
			_class = _class.replace(" ", "_")
			
			_base = _base.replace("Dialog", "")
			_base = _base.capitalize()
			_base = _base.replace(" ", "_")
			_base = _base.to_lower()
			
			script_class["base"] = _base
			script_class["class"] = _class
			ProjectSettings.set(setting_path.format(script_class), _path)
	ProjectSettings.save()
	DialogUtil.Logger.print_debug(self, "done")

func get_base_script_until_null(script:Script) -> Script:
	if script.get_base_script() == null or not is_instance_valid(script.get_base_script()):
		return script
	return get_base_script_until_null(script.get_base_script())


func handles(object: Object) -> bool:
	return object is DialogTimelineResource


func edit(object: Object) -> void:
	DialogUtil.Logger.print_debug(self, "Modifying {0}".format([object.resource_path]))
	_timeline_editor_view.set("base_resource", object)


func make_visible(visible: bool) -> void:
	if is_instance_valid(_dock_button):
		_dock_button.visible = visible
		_dock_button.pressed = visible


func save_all() -> void:
	if is_instance_valid(_timeline_editor_view):
		_timeline_editor_view.save_resource()


func save_external_data() -> void:
	save_all()


func apply_changes() -> void:
	save_all()


func build() -> bool:
	save_all()
	return true


func _exit_tree() -> void:
	if _timeline_editor_view:
		remove_control_from_bottom_panel(_timeline_editor_view)
		_timeline_editor_view.free()
