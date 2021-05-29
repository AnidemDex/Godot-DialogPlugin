tool
class_name DialogCharacterEvent
extends DialogEventResource

var character:DialogCharacterResource = null
var selected_portrait:DialogPortraitResource = null

func _get_property_list() -> Array:
	var _properties:Array = []
	_properties.append(
		{
			"name":"character",
			"type":TYPE_OBJECT,
			"hint":PROPERTY_HINT_RESOURCE_TYPE,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		}
	)
	_properties.append(
		{
			"name":"selected_portrait",
			"type":TYPE_OBJECT,
			"hint":PROPERTY_HINT_RESOURCE_TYPE,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		}
	)
	return _properties
