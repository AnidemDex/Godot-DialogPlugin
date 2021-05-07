tool
extends OptionButton

const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")

func _ready() -> void:
	clear()
	
	var _idx:int = 0
	for locale in TranslationService.get_locales():
		# FIXME: TranslationServer.get_locale_name returns the locale name in english
		# This can be solved if the TranslationService translate the locale names
		var _locale_string = TranslationServer.get_locale_name(locale)
		add_item(_locale_string)
		set_item_metadata(_idx, locale)
		if locale == TranslationService.get_project_locale(true):
			select(_idx)
		_idx += 1
