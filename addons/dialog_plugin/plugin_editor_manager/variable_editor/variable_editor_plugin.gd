tool
extends EditorPlugin

const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")
const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")
const PLUGIN_NAME = "Variable Editor Manager"

var _variable_editor_view
var _variable_editor_scene:PackedScene
var interface = get_editor_interface()

func get_class(): return "VariableEditorManager"

func _init() -> void:
	name = PLUGIN_NAME


func _enter_tree() -> void:
	DialogUtil.Logger.print_debug(self, PLUGIN_NAME+" initialized.")
	_add_variable_editor()


func _exit_tree() -> void:
	_remove_variable_editor()


func _add_variable_editor() -> void:
	_variable_editor_scene = load(DialogResources.VARIABLE_EDITOR_PATH)
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
	_variable_editor_view.queue_free()
