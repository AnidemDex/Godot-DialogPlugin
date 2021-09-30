tool
class_name DialogCharacterEvent
extends DialogEventResource

##
## Base Event Class for every event related to a character
##

## The character used for this event.
var character:DialogCharacterResource = null setget set_character

## The portrait index selected for this event.
var selected_portrait:int = 0 setget set_selected_portrait

func _init() -> void:
	event_color = Color("#4CB963")


## Returns the portrait selected according to selected_portrait or null if none is selected.
func get_selected_portrait() -> DialogPortraitResource:
	var _selected_portrait:DialogPortraitResource = null
	if character and selected_portrait != -1:
		_selected_portrait = character.portraits[selected_portrait]
	return _selected_portrait


func set_character(value:DialogCharacterResource) -> void:
	character = value
	emit_changed()


func set_selected_portrait(value:int) -> void:
	selected_portrait = value
	emit_changed()


func _get(property: String):
	if property == "selected_portrait_alternative_node":
		return load("res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/numeric_property/portrait_list.tscn")


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
