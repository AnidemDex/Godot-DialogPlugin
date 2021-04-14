tool
class_name DialogDatabaseResource
extends Resource

const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")

export(Resource) var resources = null setget _set_resources


func add(item):
	assert(false)

func remove(item):
	assert(false)

func save(path: String) -> void:
	var _err = ResourceSaver.save(path, self, ResourceSaver.FLAG_CHANGE_PATH)
	if _err != OK:
		push_error("FATAL_ERROR: "+str(_err))


func _to_string() -> String:
	return "[DatabaseResource]"

func _set_resources(value):
	if not value:
		resources = ResourceArray.new()
		return
	resources = value
	emit_signal("changed")
