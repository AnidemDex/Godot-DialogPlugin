tool

const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")

class _DB:
	static func get_paths() -> Array:
		var _paths = get_database().resources
		return _paths
	
	static func get_database() -> DialogDatabaseResource:
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

static func get_editor_configuration() -> Resource:
	var _config = load(DialogResources.CONFIGURATION_PATH)
	return _config
