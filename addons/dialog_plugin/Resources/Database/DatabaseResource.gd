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
