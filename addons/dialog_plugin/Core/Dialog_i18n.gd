tool

const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")
const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")

static func load_editor_translations() -> void:
	var editor_i18n:Array = (load(DialogResources.EDITOR_i18n_PATH) as DialogDatabaseResource).resources.get_resources()
	for translation in editor_i18n:
		TranslationService.add_translation(translation)


static func remove_editor_translations() -> void:
	var editor_i18n:Array = (load(DialogResources.EDITOR_i18n_PATH) as DialogDatabaseResource).resources.get_resources()
	for translation in editor_i18n:
		TranslationService.remove_translation(translation)


static func load_translations() -> void:
	var _translations:Array = Array(load(DialogResources.TRANSLATIONSDB_PATH).resources.get_resources())
	for translation in _translations:
		TranslationService.add_translation(translation)
