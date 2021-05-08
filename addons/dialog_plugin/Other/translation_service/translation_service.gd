tool
## Alternative to [TranslationServer] that works inside the editor
## Modified to work with [Dialog Editor](https://github.com/AnidemDex/Godot-DialogPlugin)
## Made by: AnidemDex

## Not exposed since i don't want to populate the user editor with this class


## Translates a message using translation catalogs configured in the Project Settings.
static func translate(message:String, from:String="")->String:
	var translation
	
#	translation = _get_translation(message, from)

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
## Each value is an Array of [PHashTranslation] or [Translation].
static func get_translations() -> Dictionary:
	# Related issues:
	# https://github.com/godotengine/godot/issues/38862 | https://github.com/godotengine/godot/issues/38935
	
	var translations_resources:PoolStringArray = get_project_translations()
	var translations = {}
	
	for resource in translations_resources:
		var t:Translation = load(resource)
		if translations.has(t.locale):
			translations[t.locale].append(t)
		else:
			translations[t.locale] = [t]
	return translations

# https://docs.godotengine.org/en/stable/tutorials/i18n/locales.html
## Maybe this is intended, but for some reason you can't get the supported
## locales by the engine, just locales supported in game.
static func get_locales() -> Array:
	# FIXME: Add the whole locale list
	var locales:Array = [
		"en",
		"es",
	]
	
	return locales


# This is not the best way to do it, but since this is supposed to be called
# only inside the editor AND by a plugin, it's ok, i guess.
static func get_editor_locale() -> String:
	# Default fallback
	var _locale = "en"
	
	if Engine.editor_hint:
		var _editor_plugin = EditorPlugin.new()
		_locale = _editor_plugin.get_editor_interface().get_editor_settings().get_setting("interface/editor/editor_language")
		_editor_plugin.free()
	else:
		# Just if someone try to get the editor locale in game for some reason
		_locale = TranslationServer.get_locale()
	
	return _locale


static func get_project_locale(ignore_test_locale = false) -> String:
	# Default fallback
	var _locale = "en"
	var _test_locale = get_project_test_locale()
	_locale = TranslationServer.get_locale()
	
	if not ignore_test_locale and _test_locale:
		_locale = _test_locale

	return _locale


static func get_project_default_fallback() -> String:
	return ProjectSettings.get_setting("locale/fallback")


static func get_project_test_locale() -> String:
	return ProjectSettings.get_setting("locale/test")


static func get_project_translations() -> PoolStringArray:
	
	# This must be done once, since the property doesn't exist if you never a translation before
	if not ProjectSettings.get_setting("locale/translations"):
		var _empty_poolstringarray = PoolStringArray([])
		ProjectSettings.set_setting("locale/translations", _empty_poolstringarray)
		ProjectSettings.save()
	var _translations = ProjectSettings.get_setting("locale/translations")
	
	return _translations


static func add_translation(translation_resource:Translation) -> void:
	if not Engine.editor_hint:
		TranslationServer.add_translation(translation_resource)
	else:
		var _translation_path:String = translation_resource.resource_path
		if not _translation_path:
			return
		
		var _translations:Dictionary = get_translations()
		if translation_resource in _translations.get(translation_resource.locale, {}):
			# Translation found
			remove_translation(translation_resource)
		
		var _translations_paths:PoolStringArray = get_project_translations()
		_translations_paths.append(_translation_path)
		
		ProjectSettings.set_setting("locale/translations", _translations_paths)
		var _err = ProjectSettings.save()
		assert(_err == OK)


static func remove_translation(translation_resource:Translation) -> void:
	if not Engine.editor_hint:
		TranslationServer.remove_translation(translation_resource)
	else:
		var _translation_path:String = translation_resource.resource_path
		if not _translation_path:
			return
		
		var _translations_paths:Array = Array(get_project_translations())
		if _translation_path in _translations_paths:
			_translations_paths.erase(_translation_path)
		
		ProjectSettings.set_setting("locale/translations", PoolStringArray(_translations_paths))
		var _err = ProjectSettings.save()
		assert(_err == OK)


static func _translate_node(node:Node) -> void:
	var HINT_TOOLTIP_KEY = "HINT_TOOLTIP_KEY"
	var TEXT_KEY = "TEXT_KEY"
	
	var editor_locale = get_editor_locale()
	
	if node.has_meta(HINT_TOOLTIP_KEY):
		(node as Control).hint_tooltip = translate(node.get_meta(HINT_TOOLTIP_KEY), editor_locale)
	
	if node.has_meta(TEXT_KEY):
		node.text = translate(node.get_meta(TEXT_KEY), editor_locale)


static func _get_translation(_msg:String, _override_locale:String="", _used_already=false)->String:
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
		_translations.get(_default_fallback, [Translation.new()])
		)
	
	for case in cases:
		_returned_translation = (case as Translation).get_message(_msg)
		if _returned_translation:
			break
	
	if _returned_translation == _msg and not _used_already:
		# Since there's no translation, use the fallback instead
		_returned_translation = _get_translation(_msg, _default_fallback, true)
	
	if not _returned_translation:
		# Finally, since there's no really a translation, return the original string
		_returned_translation = _msg
	
	return _returned_translation

# Unused, since i can't override Object methods
#static func tr(message:String)->String:
#    return translate(message)


