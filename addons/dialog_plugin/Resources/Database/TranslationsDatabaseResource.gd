tool
#extends DialogDatabaseResource

var DialogUtil := load("res://addons/dialog_plugin/Core/DialogUtil.gd")

var resource_type
var scanned_directory

# Deprecated
func _init() -> void:
	return
	resource_type = Translation
	
	# Hardcoded since nobody is going to change this path, right?
	scanned_directory = DialogResources.TRANSLATIONS_DIR

# Deprecated
func add(item:Translation) -> void:
	return
	DialogUtil.Logger.print(self, ["Adding a translation: ", item.resource_path])
	if resources.get_resources().has(item):
		push_warning("A resource is already there")
		var _r_array = resources.get_resources()
		var _idx = _r_array.find(item)
		if _idx != -1:
			_r_array[_idx] = item
			save(DialogResources.TRANSLATIONSDB_PATH)
			emit_signal("changed")
		return
	
	(resources as ResourceArray).add(item)
	save(DialogResources.TRANSLATIONSDB_PATH)
	emit_signal("changed")
	pass
