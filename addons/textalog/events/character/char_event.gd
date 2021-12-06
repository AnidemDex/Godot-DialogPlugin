tool
extends Event

##
## Base Event Class for every event related to a character
##

## The character used for this event.
var character:Character = null setget set_character

## The portrait index selected for this event.
var selected_portrait:int = 0 setget set_selected_portrait

func _init() -> void:
	event_color = Color("4CB963")
	event_category = "Character"


## Returns the portrait selected according to selected_portrait or null if none is selected.
func get_selected_portrait() -> Portrait:
	var _selected_portrait:Portrait = null
	if character and selected_portrait != -1:
		_selected_portrait = character.portraits[selected_portrait]
	return _selected_portrait


func set_character(value:Character) -> void:
	character = value
	emit_changed()


func set_selected_portrait(value:int) -> void:
	selected_portrait = value
	emit_changed()

func _get(property: String):
	if property == "character_name":
		if character:
			return character.display_name
		else:
			return "???"
	
	if property == "expression_name":
		var xpsn := get_selected_portrait()
		if xpsn:
			return xpsn.get("name")
		else:
			return "???"
		

func _get_property_list() -> Array:
	var p := []
	p.append(
		{"type":TYPE_STRING,"name":"character_name", "usage":0}
	)
	p.append(
		{"type":TYPE_STRING, "name":"expression_name", "usage":0}
	)
	return p
