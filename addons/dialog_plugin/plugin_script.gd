tool
extends EditorPlugin

const PLUGIN_NAME = "Dialog Editor"
const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")
const Dialog_i18n = preload("res://addons/dialog_plugin/Core/Dialog_i18n.gd")

var interface = get_editor_interface()

var _editor_view
var _variable_editor_view
var _parts_inspector
var _translation_inspector

var _timeline_editor_scene:PackedScene
var _character_editor_scene:PackedScene
var _variable_editor_scene:PackedScene


var _last_file_selected:String = ""
var _file_selected:String = ""

func _enter_tree() -> void:
	if not load(DialogResources.CONFIGURATION_PATH).enabled:
		return
	DialogResources.verify_resource_directories()
	_add_editor_translations()
	
	_timeline_editor_scene = load(DialogResources.TIMELINE_EDITOR_PATH)
	_character_editor_scene = load(DialogResources.CHARACTER_EDITOR_PATH)
	_variable_editor_scene = load(DialogResources.VARIABLE_EDITOR_PATH)
	
	_add_editor_inspector_plugins()
	_add_variable_editor()


func _ready() -> void:
	if Engine.editor_hint:
		# Force Godot to show the Dialog folder
		get_editor_interface().get_resource_filesystem().scan()


func _process(delta):
	_file_selected = interface.get_current_path()
	if _file_selected != _last_file_selected:
		_last_file_selected = _file_selected
		_remove_main_editor()
		if _last_file_selected.get_extension() == "tres":
			_add_main_editor()


func _exit_tree() -> void:
	_remove_main_editor()
	_remove_variable_editor()
	_remove_editor_inspector_plugins()
	_remove_editor_translations()


func get_plugin_name() -> String:
	return PLUGIN_NAME


func _add_editor_inspector_plugins() -> void:
	_parts_inspector = load("res://addons/dialog_plugin/Core/DialogInspector.gd").new()
	_translation_inspector = load("res://addons/dialog_plugin/Other/translation_service/translation_inspector.gd").new()
	add_inspector_plugin(_parts_inspector)
	add_inspector_plugin(_translation_inspector)


func _remove_editor_inspector_plugins() -> void:
	if _parts_inspector:
		remove_inspector_plugin(_parts_inspector)
	if _translation_inspector:
		remove_inspector_plugin(_translation_inspector)
		# For some reason that i don't know, i have to force an unreference to this object
		_translation_inspector.unreference() 
	
	_parts_inspector = null
	_translation_inspector = null


func _add_editor_translations() -> void:
	load("res://addons/dialog_plugin/Database/Editor_i18n.tres").scan_resources_folder()
	Dialog_i18n.load_editor_translations()


func _remove_editor_translations() -> void:
	Dialog_i18n.remove_editor_translations()


func _add_main_editor() -> void:
	var _editor_scene:PackedScene = null
	var _res_selected = null
	var _title = ""
	
	if ResourceLoader.exists(_file_selected):
		_res_selected = ResourceLoader.load(_file_selected, "", true)
	
	if _res_selected is DialogTimelineResource:
		_editor_scene = _timeline_editor_scene
		_title = "Timeline Editor"
	elif _res_selected is DialogCharacterResource:
		_editor_scene = _character_editor_scene
		_title = "Character Editor"
	
	if _editor_scene:
		_editor_view = _editor_scene.instance()
		_editor_view.base_resource = _res_selected
		var _dock_button = add_control_to_bottom_panel(_editor_view, _title)
		_dock_button.pressed = true


func _remove_main_editor() -> void:
	if _editor_view and is_instance_valid(_editor_view):
		remove_control_from_bottom_panel(_editor_view)
		_editor_view.free()
	_editor_view = null


func _add_variable_editor() -> void:
	_variable_editor_view = WindowDialog.new()
	_variable_editor_view.rect_min_size = Vector2(640,480)
	var _var_editor = _variable_editor_scene.instance()
	_variable_editor_view.add_child(_var_editor)
	interface.get_base_control().add_child(_variable_editor_view)
	
	add_tool_menu_item("Variable editor", self, "_show_variable_editor")


func _show_variable_editor(_param) -> void:
	_variable_editor_view.popup_centered()


func _remove_variable_editor() -> void:
	remove_tool_menu_item("Variable editor")
	_variable_editor_view.free()
