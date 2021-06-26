tool
extends HBoxContainer

enum TYPES {BOOL, STRING, INT, FLOAT, COLOR, ENUM}


export(TYPES) var type:int = 0 setget _set_type
export(String) var variable_name:String = ""

var default_value = null

var type_match = {
	TYPES.BOOL: TYPE_BOOL,
	TYPES.COLOR: TYPE_COLOR,
	TYPES.STRING: TYPE_STRING,
	TYPES.INT: TYPE_INT,
	TYPES.FLOAT: TYPE_REAL,
	TYPES.ENUM: TYPE_ARRAY
}

var type_hint = {
	TYPES.FLOAT: [PROPERTY_HINT_RANGE, "0,100"]
}

func _set_type(value:int) -> void:
	type = value
	property_list_changed_notify()


func _get_property_list() -> Array:
	var properties = []
	properties.append({
		"name":"default_value",
		"type":type_match.get(type, TYPE_NIL),
		"hint":type_hint.get(type, [PROPERTY_HINT_NONE])[0],
		"hint_string":type_hint.get(type, ["",""])[1],
		"usage":PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	return properties

