tool
class_name DialogCharacterEvent
extends DialogEventResource

var character:DialogCharacterResource = null
var selected_portrait:int = -1

func get_selected_portrait() -> DialogPortraitResource:
	var _selected_portrait:DialogPortraitResource = null
	if character and selected_portrait != -1:
		_selected_portrait = character.portraits.get_resources()[selected_portrait]
	return _selected_portrait

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
			"type":TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		}
	)
	return _properties
