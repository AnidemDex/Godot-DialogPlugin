tool

const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")

class _DB:
	static func get_paths() -> Array:
		var _paths = get_database().resources
		return _paths
	
	
	static func get_database() -> DialogDatabaseResource:
		push_warning("Returning an empty database")
		return DialogDatabaseResource.new()
	
	
	static func add(name) -> void:
		assert(false)
	
#	static func get_*() -> Array:


class Timelines extends _DB:
	
	static func get_database() -> DialogDatabaseResource:
		var _db = ResourceLoader.load(DialogResources.TIMELINEDB_PATH)
		return _db
	
	static func add(name:String) -> void:
		var file_name = "{name}.tres".format({"name":name})
		var file_path = DialogResources.TIMELINES_DIR+"{file_name}".format({"file_name":file_name})
		var _n_tl = DialogTimelineResource.new()
		_n_tl.resource_name = name
		_n_tl.resource_path = file_path

		var _err = ResourceSaver.save(
			file_path, 
			_n_tl
			)
		assert(_err == OK)
		get_database().add(_n_tl)
	
	static func get_timelines() -> Array:
		return get_database().resources.get_resources()
	
	static func get_timeline(timeline_name:String) -> DialogTimelineResource:
		var _timeline = null
		for timeline in get_timelines():
			if timeline.resource_path.get_file().replace(".tres", "") == timeline_name:
				_timeline = timeline
				break
		
		return _timeline


class Characters extends _DB:
	
	static func get_database() -> DialogDatabaseResource:
		var _db = ResourceLoader.load(DialogResources.CHARACTERDB_PATH)
		return _db
	
	static func add(name:String) -> void:
		var file_name:String = "{name}.tres".format({"name":name})
		var file_path:String = DialogResources.CHARACTERS_DIR+file_name
		var _n_char:DialogCharacterResource = DialogCharacterResource.new() if not ResourceLoader.exists(file_path) else ResourceLoader.load(file_path)
		
		_n_char.resource_name = name
		_n_char.resource_path = file_path
		_n_char.name = name
		
		var _err = ResourceSaver.save(file_path, _n_char)
		assert(_err == OK)
		get_database().add(_n_char)
	
	
	static func get_characters() -> Array:
		return get_database().resources.get_resources()
	
	
	static func get_character(character_name:String) -> DialogCharacterResource:
		var _character = null
		for character in get_characters():
			if character.name == character_name:
				_character = character
				break
		
		return _character


class Definitions extends _DB:
	pass

class Themes extends _DB:
	pass


class EditorTranslations extends _DB:
	static func get_database() -> DialogDatabaseResource:
		var _db = ResourceLoader.load(DialogResources.EDITOR_i18n_PATH)
		return _db


class Translations extends _DB:
	const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")
	const Dialog_i18n = preload("res://addons/dialog_plugin/Core/Dialog_i18n.gd")
	
	static func get_database() -> DialogDatabaseResource:
		var _db = ResourceLoader.load(DialogResources.TRANSLATIONSDB_PATH)
		return _db
	
	
	static func add_message(src_message, xlated_message, from:Resource) -> void:
		# Verifica si la traducción existe
		get_database().scan_resources_folder()
		Dialog_i18n.load_translations()
		var _translation = TranslationService.translate(src_message)
		var _locale = TranslationService.get_project_locale()
		var _n_translation:Translation = null
		var _name = from.resource_path.get_file().replace(".tres","")
		var _file_name:String = "{name}.{locale}.translation".format({"name":_name, "locale":_locale})
		var _file_path:String = DialogResources.TRANSLATIONS_DIR+_file_name
		
		if _translation != src_message:
			if ResourceLoader.exists(_file_path):
				_n_translation = ResourceLoader.load(_file_path) as Translation
		elif not ResourceLoader.exists(_file_path):
				_n_translation = Translation.new()

		
		if _n_translation:
			_n_translation.resource_path = _file_path
			_n_translation.resource_name = "[{locale}] {name}".format({"name":_name, "locale":_locale})
			_n_translation.locale = TranslationService.get_project_locale()
			_n_translation.add_message(src_message, xlated_message)
			
			# I really don't want to populate this with comments, but this one
			# is a very special exception. May be removed
#			print_debug(
#				"Locale-> ",_locale,
#				"\t",
#				"ID-> ", src_message, 
#				"\t",
#				"Suggested xlation-> ", xlated_message,
#				"\t",
#				"xlation-> ", _translation,
#				"\t",
#				"xlation in n-> ", _n_translation.get_message(src_message),
#				"\t",
#				"Name->", _n_translation.resource_name,
#				"\t",
#				"Path->",_n_translation.resource_path
#				)
		
			var _err = ResourceSaver.save(_file_path, _n_translation)
			assert(_err == OK)
		
			get_database().add(_n_translation)
		
		get_database().scan_resources_folder()
		Dialog_i18n.load_translations()
	
	
	static func remove_message(src_message) -> void:
		pass


static func get_editor_configuration() -> Resource:
	var _config = load(DialogResources.CONFIGURATION_PATH)
	return _config
