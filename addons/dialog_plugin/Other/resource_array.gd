tool
class_name ResourceArray
extends Resource
# author: 
# 	AnidemDex (aka DexAnidem)
# description:
# 	Stores an Array of Resources

# 	Because exporting Arrays results in globally shared Array references,
# 	this simulates all of its data as individual properties.
#
# 	The above bug is fixed in 4.0 via godotengine/godot#41983.
# 	based on array_map.gd from willnationsdev


# Este script me costó un huevo, en serio.
# Pero será util para guardar recursos sin exportarlos
# directamente, y es mas simple que "recurso,valor"

var _resources:Array = []

## Para modificar el tipo de recurso a usar en el editor
var _hint_string = "Resource"

var _current_iter = 0

func _init() -> void:
	property_list_changed_notify()

## add a resource at the end of the array
func add(resource:Resource) -> void:
	_resources.append(resource)
	property_list_changed_notify()
	emit_signal("changed")

## remove a resource from the array
func remove(resource:Resource) -> void:
	_resources.erase(resource)
	property_list_changed_notify()
	emit_signal("changed")

func get_resources() -> Array:
	return _resources

func _get(property: String):
	if property.begins_with("values/"):
		var _idx = int(property.replace("values/",""))
		if _idx < _resources.size() and _idx >= 0:
			return _resources[_idx]
	return null


func _set(property: String, value) -> bool:
	if property.begins_with("values/"):
		var _idx = int(property.replace("values/", ""))
		if _idx < _resources.size() and _idx >= 0:
			_resources[_idx] = value
			return true

	return false

func _get_property_list() -> Array:
	var properties:Array = []
	properties.append(
		{
			"name":"_resources",
			"type": TYPE_ARRAY,
			"usage": PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_NOEDITOR
		}
	)
	if _resources.empty():
		properties.append(
			{
				"name":"info",
				"type": TYPE_NIL,
				"hint": PROPERTY_HINT_NONE,
				"usage": PROPERTY_USAGE_NO_INSTANCE_STATE | PROPERTY_USAGE_EDITOR,
			}
		)
	else:
		for index in _resources.size():
			properties.append(
				{
					"name":"values/"+str(index),
					"type": TYPE_OBJECT,
					"hint": PROPERTY_HINT_RESOURCE_TYPE,
					"hint_string": _hint_string,
					"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
				}
			)
	return properties


func _should_iter_continue() -> bool:
	return (_current_iter < _resources.size())


func _iter_init(arg) -> bool:
	_current_iter = 0
	return _should_iter_continue()


func _iter_next(arg) -> bool:
	_current_iter += 1
	return _should_iter_continue()


func _iter_get(arg):
	return _resources[_current_iter]
