tool
extends EditorPlugin

const PLUGIN_NAME = "Dialog Editor Plugin"
const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")
const Dialog_i18n = preload("res://addons/dialog_plugin/Core/Dialog_i18n.gd")
const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")

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

func get_class(): return "DialogEditorPlugin"


func _enter_tree() -> void:
#	_add_editor_translations()
#	_add_editor_inspector_plugins()
	pass


func enable_plugin() -> void:
	enable_all_modules()
	
	if not can_proceed():
		force_plugin_disable()
		return
	
	show_alert()
	DialogUtil.Logger.print_info(self, "Plugin enabled.")


func enable_all_modules() -> void:
	for module in modules:
		interface.set_plugin_enabled(module, true)
	DialogUtil.Logger.print_debug(self, "All modules enabled... probably.")


func disable_all_modules() -> void:
	for module in modules:
		if interface.is_plugin_enabled(module):
			interface.set_plugin_enabled(module, false)
	DialogUtil.Logger.print_debug(self, "All modules disabled.")


func verify_all_modules() -> int:
	for module in modules:
		var _enabled = interface.is_plugin_enabled(module)
		if not _enabled:
			DialogUtil.Logger.print_info(self, "Module <<{module}>> is not enabled. Maybe something went wrong when the plugin was being initialized?".format({"module":module.get_file()}))
			return ERR_SCRIPT_FAILED
	
	return OK


func verify_plugin() -> int:
	if verify_all_modules() != OK:
		return ERR_SCRIPT_FAILED
	return OK


func can_proceed() -> bool:
	return verify_plugin() == OK


func force_plugin_disable() -> void:
	DialogUtil.Logger.print_error(self, "The plugin found an error. It'll be disabled.")
	disable_plugin()
	interface.set_plugin_enabled("dialog_plugin", false)


func show_alert() -> void:
	var alert_popup:AcceptDialog = load("res://addons/dialog_plugin/Editor/Popups/activation_alert/activation_alert.tscn").instance()
	interface.add_child(alert_popup)
	alert_popup.connect("hide", alert_popup, "queue_free")
	alert_popup.popup_centered()
	DialogUtil.Logger.print_debug(self, "Showing startup alert.")


func disable_plugin() -> void:
	disable_all_modules()
	DialogUtil.Logger.print_info(self, "Plugin disabled.")


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
