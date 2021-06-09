tool
extends EditorPlugin

const PLUGIN_NAME = "Dialog Editor Plugin"
const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")
const Dialog_i18n = preload("res://addons/dialog_plugin/Core/Dialog_i18n.gd")

var interface:EditorInterface = get_editor_interface()

var _parts_inspector
var _translation_inspector

var modules = [
	DialogResources.TIMELINE_PLUGIN_MANAGER,
	DialogResources.CHARACTER_PLUGIN_MANAGER,
	DialogResources.VARIABLE_PLUGIN_MANAGER,
]

func _init() -> void:
	name = PLUGIN_NAME


func _enter_tree() -> void:
	if not load(DialogResources.CONFIGURATION_PATH).enabled:
		return
	DialogResources.verify_resource_directories()
	_add_editor_translations()
	
	_add_editor_inspector_plugins()


func _ready() -> void:
	get_editor_interface().get_resource_filesystem().scan()


func enable_plugin() -> void:
	for module in modules:
		interface.set_plugin_enabled(module, true)


func disable_plugin() -> void:
	for module in modules:
		if interface.is_plugin_enabled(module):
			interface.set_plugin_enabled(module, false)


func _exit_tree() -> void:
	_remove_editor_inspector_plugins()
	_remove_editor_translations()


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
