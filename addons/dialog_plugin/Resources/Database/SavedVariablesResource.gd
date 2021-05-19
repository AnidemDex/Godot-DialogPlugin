tool
extends Resource

var variables:Dictionary = {} setget _set_variables_dict, _get_variables_dict

func set_value(key:String, value) -> void:
	variables[key] = value


func get_original_variables() -> Dictionary:
	return variables


func _is_valid_dictionary(dict:Dictionary) -> bool:
	for key in dict.keys():
		if typeof(key) != TYPE_STRING:
			return false
	return true


func _set_variables_dict(value:Dictionary) -> void:
	if _is_valid_dictionary(value):
		variables = value.duplicate(true)


func _get_variables_dict() -> Dictionary:
	return variables.duplicate(true)


func _get_property_list() -> Array:
	var _prop:Array = [
		{
			"name":"variables",
			"type":TYPE_DICTIONARY,
			"usage":PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		}
	]
	return _prop
