tool
## Alternative to [TranslationServer] that works inside the editor
## Modified to work with [Dialog Editor](https://github.com/AnidemDex/Godot-DialogPlugin)
## Made by: AnidemDex

## Not exposed since i don't want to populate the user editor with this class


## Translates a message using translation catalogs configured in the Project Settings.
static func translate(message:String, from:String="")->String:
	var translation

	if Engine.editor_hint:
		translation = _get_translation(message, from)
		
	else:
		translation = TranslationServer.translate(message)
	
	return translation


static func translate_node_recursively(base_node:Control) -> void:
	for node in base_node.get_children():
		if node.get_child_count() > 0:
			_translate_node(node)
			translate_node_recursively(node)
		else:
			_translate_node(node)
	_translate_node(base_node)


## Returns a dictionary using translation catalogs configured in the Project Settings.
## Each key correspond to [locale](https://docs.godotengine.org/en/stable/tutorials/i18n/locales.html).
## Each value is an Array of [PHashTranslation].
static func get_translations() -> Dictionary:
	var translations_resources:PoolStringArray = ProjectSettings.get_setting("locale/translations")
	var translations = {}
	
	for resource in translations_resources:
		var t:PHashTranslation = load(resource)
		if translations.has(t.locale):
			translations[t.locale].append(t)
		else:
			translations[t.locale] = [t]
	return translations

# This is not the best way to do it, but since this is supposed to be called
# only inside the editor AND by a plugin, it's ok, i guess.
static func get_editor_locale() -> String:
	var _locale = EditorPlugin.new().get_editor_interface().get_editor_settings().get_setting("interface/editor/editor_language")
	return _locale


static func _translate_node(node:Node) -> void:
	var HINT_TOOLTIP_KEY = "HINT_TOOLTIP_KEY"
	var TEXT_KEY = "TEXT_KEY"
	
	var editor_locale = get_editor_locale()
	
	if node.has_meta(HINT_TOOLTIP_KEY):
		(node as Control).hint_tooltip = translate(node.get_meta(HINT_TOOLTIP_KEY), editor_locale)
	
	if node.has_meta(TEXT_KEY):
		node.text = translate(node.get_meta(TEXT_KEY), editor_locale)


static func _get_translation(_msg:String, _override_locale:String="")->String:
	var _returned_translation:String = _msg
	var _translations:Dictionary = get_translations()
	var _default_fallback:String = ProjectSettings.get_setting("locale/fallback")
	var _test_locale:String = ProjectSettings.get_setting("locale/test")
	var _locale = TranslationServer.get_locale() if not _override_locale else _override_locale
	
	if _test_locale and not _override_locale:
		# There's a test locale property defined, use that instead editor locale
		_locale = _test_locale

	var cases = _translations.get(
		_locale, 
		_translations.get(_default_fallback, [PHashTranslation.new()])
		)
	
	for case in cases:
		_returned_translation = (case as PHashTranslation).get_message(_msg)
		if _returned_translation:
			break
		else:
			# Since there's no translation, use the fallback instead
			_returned_translation = _get_translation(_msg, _default_fallback)
			if not _returned_translation:
				# If there's no translation, returns the original string
				_returned_translation = _msg
	
	return _returned_translation

# Unused, since i can't override Object methods
#static func tr(message:String)->String:
#    return translate(message)


