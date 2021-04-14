tool
extends EditorPlugin

const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")
const EditorView_Scene = preload("res://addons/dialog_plugin/Editor/EditorView.tscn")

var _editor_view
var _parts_inspector

func _enter_tree() -> void:
	if not load(DialogResources.CONFIGURATION_PATH).enabled:
		return
	DialogResources.verify_resource_directories()
	_parts_inspector = load("res://addons/dialog_plugin/Core/DialogInspector.gd").new()
	_editor_view = EditorView_Scene.instance()
	
	add_inspector_plugin(_parts_inspector)
	
	get_editor_interface().get_editor_viewport().add_child(_editor_view)
	
	make_visible(false)


func _ready() -> void:
	if Engine.editor_hint:
		# Force Godot to show the Dialog folder
		get_editor_interface().get_resource_filesystem().scan()


func _exit_tree() -> void:
	if _editor_view:
		_editor_view.queue_free()
	pass


func has_main_screen() -> bool:
	return true


func get_plugin_name() -> String:
	return "Dialog"


# Copied
func get_plugin_icon():
	# https://github.com/godotengine/godot-proposals/issues/572
	if get_editor_interface().get_editor_settings().get_setting("interface/theme/base_color").v > 0.5:
		return load(DialogResources.ICON_PATH_LIGHT)
	return load(DialogResources.ICON_PATH_DARK)


func make_visible(visible: bool) -> void:
	if _editor_view:
		_editor_view.visible = visible
