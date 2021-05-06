tool
extends DialogDatabaseResource

var DialogUtil := load("res://addons/dialog_plugin/Core/DialogUtil.gd")

func _init() -> void:
	resource_type = Translation
	
	# Hardcoded since nobody is going to change this path, right?
	scanned_directory = "res://addons/dialog_plugin/editor_translations/"

# Copied
func add(item:Translation) -> void:
	DialogUtil.Logger.print(self, ["Adding a translation: ", item.resource_path])
	if resources.get_resources().has(item):
		push_warning("A resource is already there")
		var _r_array = resources.get_resources()
		var _idx = _r_array.find(item)
		if _idx != -1:
			_r_array[_idx] = item
			save(DialogResources.EDITOR_i18n_PATH)
			emit_signal("changed")
		return
	
	(resources as ResourceArray).add(item)
	save(DialogResources.EDITOR_i18n_PATH)
	emit_signal("changed")
	pass
