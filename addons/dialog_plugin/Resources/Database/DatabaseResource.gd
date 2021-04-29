tool
class_name DialogDatabaseResource
extends Resource

const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")

# ResourceArray
var resources = null setget _set_resources


func add(item):
	assert(false)

func remove(item):
	assert(false)

func save(path: String) -> void:
	var _err = ResourceSaver.save(path, self)
	assert(_err == OK)


func scan_resources_folder() -> void:
	push_error("You forgot to override this method. Nothing will happen until you do")


# A (finally) recursive method to see the files inside a folder
# maybe this should be inside DialogUtil instead
func _get_files_in_directory(directory_path:String) -> PoolStringArray:
	var _files = PoolStringArray()
	var _d:Directory = Directory.new()
	if _d.open(directory_path) == OK:
		_d.list_dir_begin(false, true)
		var _file_name:String = _d.get_next()
		while _file_name != "":
			if _d.current_is_dir():
				if not _file_name.begins_with("."):
					_files.append_array(_get_files_in_directory(directory_path+"/"+_file_name))
			else:
				_files.append(directory_path+"/"+_file_name)
				
			_file_name = _d.get_next()
	return _files


func _to_string() -> String:
	return "[DatabaseResource]"


func _set_resources(value):
	if not value:
		resources = ResourceArray.new()
		return
	resources = value
	emit_signal("changed")


func _get_property_list() -> Array:
	var properties:Array = []
	properties.append(
		{
			"name":"resources",
			"type":TYPE_OBJECT,
			"hint":PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string":"ResourceArray",
		}
	)
	return properties
