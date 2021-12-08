tool
extends Event

##
## Base Event Class for every event related to a character
##

## The character used for this event.
var character:Character = null setget set_character

## The portrait index selected for this event.
var selected_portrait:int = -1 setget set_selected_portrait

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
	property_list_changed_notify()


func set_selected_portrait(value:int) -> void:
	selected_portrait = value
	emit_changed()
	property_list_changed_notify()


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
	var default_usage := PROPERTY_USAGE_DEFAULT|PROPERTY_USAGE_SCRIPT_VARIABLE
	p.append({"type":TYPE_STRING,"name":"character_name", "usage":0})
	p.append({"type":TYPE_STRING, "name":"expression_name", "usage":0})
	p.append({"type":TYPE_OBJECT, "name":"character", "usage":default_usage, "hint":PROPERTY_HINT_RESOURCE_TYPE, "hint_string":"Resource"})
	
	if not get("selected_portrait_ignore"):
		var portraits_hint = "[None]:-1"
		# haha for loops goes brrrr~
		if character:
			for portrait_idx in character.portraits.size():
				var portrait = character.portraits[portrait_idx] as Portrait
				if portrait == null:
					continue
				portraits_hint += ","+portrait.name + ":%s"%portrait_idx
			
		p.append({"type":TYPE_INT, "name":"selected_portrait", "usage":default_usage, "hint":PROPERTY_HINT_ENUM, "hint_string":portraits_hint})
	return p
