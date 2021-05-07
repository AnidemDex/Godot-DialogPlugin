tool
extends DialogDatabaseResource

var DialogUtil := load("res://addons/dialog_plugin/Core/DialogUtil.gd")

func _init() -> void:
	resource_type = DialogCharacterResource
	scanned_directory = DialogResources.CHARACTERS_DIR


func add(item:DialogCharacterResource) -> void:
	DialogUtil.Logger.print(self, ["Adding a character: ", item.resource_path])
	if resources.get_resources().has(item):
		push_warning("A resource is already there")
		var _r_array = resources.get_resources()
		var _idx = _r_array.find(item)
		if _idx != -1:
			_r_array[_idx] = item
			save(DialogResources.CHARACTERDB_PATH)
			emit_signal("changed")
		return
	
	(resources as ResourceArray).add(item)
	save(DialogResources.CHARACTERDB_PATH)
	emit_signal("changed")


func remove(item:DialogCharacterResource) -> void:
	DialogUtil.Logger.print(self,["removing a character:",item.resource_path])
	(resources as ResourceArray).remove(item)
	save(DialogResources.CHARACTERDB_PATH)
	emit_signal("changed")


# Copied
#func scan_resources_folder() -> void:
#	push_warning("Scanning characters folder")
#	var _files:PoolStringArray = _get_files_in_directory(DialogResources.CHARACTERS_DIR)
#
#	for file in _files:
#		var _resource = load(file)
#		if not _resource in resources.get_resources():
#			push_warning("{} is not in the database, adding...".format({"":file.get_file()}))
#			add(_resource)
#		_resource = null
#
#	push_warning("Done")

func _to_string() -> String:
	return "[CharacterDatabase]"
