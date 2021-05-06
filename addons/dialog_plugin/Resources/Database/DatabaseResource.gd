tool
class_name DialogDatabaseResource
extends Resource

const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")

# ResourceArray
var resources:ResourceArray = null setget _set_resources
var resource_type = null
var scanned_directory:String = ""


func add(item):
	assert(false)

func remove(item):
	assert(false)

func save(path: String) -> void:
	# No, i can't use resource_path here
	var _err = ResourceSaver.save(path, self)
	assert(_err == OK)


func scan_resources_folder() -> void:
	if not resource_type:
		push_error("No resource type assigned to this database. ")
		return
	if not scanned_directory:
		push_error("No directory pointer assigned to this database.")
		return
	
	push_warning("Scanning {data_folder} folder".format({"data_folder":scanned_directory.get_base_dir().split("/")[-1]}))
	var _files:PoolStringArray = _get_files_in_directory(scanned_directory)
	
	for file in _files:
		# I should have not add this here, but since Godot treat these files
		# as resources but it doesn't have a loader, i have to. I want to avoid 
		# errors in the console
		if file.ends_with(".csv") or file.ends_with(".import"):
			continue
		var _resource = load(file)
		if not _resource in resources.get_resources() and _resource is resource_type:
			push_warning("{} is not in the database, adding...".format({"":file.get_file()}))
			add(_resource)
		_resource = null
	
	push_warning("Done")


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
