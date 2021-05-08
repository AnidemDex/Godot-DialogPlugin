tool
extends EditorPlugin

const PLUGIN_NAME = "Dialog Editor"
const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")
const EditorView_Scene = preload("res://addons/dialog_plugin/Editor/EditorMainNode.tscn")
const Dialog_i18n = preload("res://addons/dialog_plugin/Core/Dialog_i18n.gd")

var _editor_view
var _parts_inspector
var _translation_inspector

func _enter_tree() -> void:
	if not load(DialogResources.CONFIGURATION_PATH).enabled:
		return
	DialogResources.verify_resource_directories()
	_add_editor_translations()
	
	var _err = connect("main_screen_changed", self, "_on_main_screen_changed")
	
	
	_add_editor_inspector_plugins()
	
	make_visible(false)


func _ready() -> void:
	if Engine.editor_hint:
		# Force Godot to show the Dialog folder
		get_editor_interface().get_resource_filesystem().scan()


func _exit_tree() -> void:
	_remove_main_editor()
	_remove_editor_inspector_plugins()
	_remove_editor_translations()



func has_main_screen() -> bool:
	return true


func get_plugin_name() -> String:
	return PLUGIN_NAME


# Copied
func get_plugin_icon():
	# https://github.com/godotengine/godot-proposals/issues/572
	if get_editor_interface().get_editor_settings().get_setting("interface/theme/base_color").v > 0.5:
		return load(DialogResources.ICON_PATH_LIGHT)
	return load(DialogResources.ICON_PATH_DARK)


func make_visible(visible: bool) -> void:
	if _editor_view:
		_editor_view.visible = visible


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
	_editor_view = EditorView_Scene.instance()
	get_editor_interface().get_editor_viewport().add_child(_editor_view)
	pass


func _remove_main_editor() -> void:
	if _editor_view and is_instance_valid(_editor_view):
		_editor_view.free()
	_editor_view = null


func _on_main_screen_changed(screen_name:String) -> void:
	if screen_name == PLUGIN_NAME:
		_add_main_editor()
	else:
		_remove_main_editor()
