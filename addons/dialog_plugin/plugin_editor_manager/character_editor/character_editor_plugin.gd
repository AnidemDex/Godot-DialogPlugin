tool
extends EditorPlugin

const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")
const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")
const PLUGIN_NAME = "Character Editor Manager"

var _character_editor_view:Control
var _dock_button:ToolButton

func get_class(): return "CharacterEditorManager"


func _init() -> void:
	name = PLUGIN_NAME


func _enter_tree() -> void:
	DialogUtil.Logger.print_debug(self, PLUGIN_NAME+" initialized.")
	_character_editor_view = load(DialogResources.CHARACTER_EDITOR_PATH).instance()
	_dock_button = add_control_to_bottom_panel(_character_editor_view, "CharacterEditor")
	_dock_button.visible = false


func handles(object: Object) -> bool:
	return object is DialogCharacterResource


func edit(object: Object) -> void:
	DialogUtil.Logger.print_debug(self, "Modifying {0}".format([object.resource_path]))
	_character_editor_view.base_resource = object


func make_visible(visible: bool) -> void:
	if is_instance_valid(_dock_button):
		_dock_button.visible = visible
		_dock_button.pressed = visible


func save_all() -> void:
	if is_instance_valid(_character_editor_view):
		_character_editor_view._save()


func save_external_data() -> void:
	save_all()


func apply_changes() -> void:
	save_all()


func build() -> bool:
	save_all()
	return true

func _exit_tree() -> void:
	if _character_editor_view:
		remove_control_from_bottom_panel(_character_editor_view)
		_character_editor_view.free()
