tool
extends Resource
class_name Character, "res://addons/textalog/assets/icons/character_icon.png"

##
## Base class for all characters resource.
##
## @desc: 
##     Character resource acts as a data container
##     to all of your characters and related portraits to that character.
##
## @tutorial(Online Documentation): https://anidemdex.gitbook.io/godot-dialog-plugin/documentation/resource-class/class_dialog-character-resource
##

## Name of the character.
var name:String = "" setget set_name

## Name of the character that'll be displayed in game. By default, is the same as name
var display_name:String = "" setget set_display_name,get_display_name
var _display_name:String = "" setget set_display_name

## Color of the character name
export(Color) var color:Color = Color.white setget set_color

## Character icon. Used by the editor.
export(Texture) var icon:Texture setget set_icon

## Character sounds when talking.
var blip_sounds:Array = [] setget _set_blip_sounds

## Collection of portraits that'll be displayed in game
var portraits:Array = [] setget _set_portraits

func _init() -> void:
	portraits = []
	blip_sounds = []


## Adds a [DialogPortraitResource] in [member portraits]
func add_portrait(portrait) -> void:
	if not portrait in portraits:
		if not portrait.is_connected("changed", self, "emit_changed"):
			portrait.connect("changed", self, "emit_changed")
		portraits.append(portrait)
		emit_changed()


## Adds a [AudioStream] in [member blip_sounds]
func add_blip_sound(blip_sound:AudioStream) -> void:
	if not blip_sound in blip_sounds:
		blip_sounds.append(blip_sound)
		emit_changed()


## Removes a [DialogPortraitResource] from [member portraits]
func remove_portrait(portrait) -> void:
	if portrait in portraits:
		if portrait.is_connected("changed", self, "emit_changed"):
			portrait.disconnect("changed", self, "emit_changed")
		portraits.erase(portrait)
		emit_changed()



## Removes a [AudioStream] from [member blip_sounds]
func remove_blip_sound(blip_sound:AudioStream) -> void:
	if blip_sound in blip_sounds:
		blip_sounds.erase(blip_sound)
		emit_changed()


func set_name(value:String) -> void:
	name = value
	resource_name = value
	property_list_changed_notify()
	emit_changed()


func set_display_name(value:String) -> void:
	display_name = value
	emit_changed()
	property_list_changed_notify()


func set_color(value:Color) -> void:
	color = value
	emit_changed()


func set_icon(value:Texture) -> void:
	icon = value
	emit_changed()

func _set_blip_sounds(value:Array) -> void:
	blip_sounds = value.duplicate()
	emit_changed()
	property_list_changed_notify()


func get_display_name() -> String:
	if display_name:
		return display_name
	else:
		return name


func _get_property_list() -> Array:
	var p:Array = []
	var default_usage := PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
	p.append({"type":TYPE_STRING, "name":"name", "usage":default_usage, "hint":PROPERTY_HINT_PLACEHOLDER_TEXT, "hint_string":name})
	p.append({"type":TYPE_STRING, "name":"_display_name", "usage":default_usage, "hint":PROPERTY_HINT_PLACEHOLDER_TEXT, "hint_string":name})
	p.append({"type":TYPE_ARRAY, "name":"blip_sounds", "usage":default_usage, "hint":24, "hint_string":"17/17:AudioStream"})
	
	p.append({"type":TYPE_NIL, "name":"Portraits", "usage":PROPERTY_USAGE_CATEGORY})
	p.append({"type":TYPE_ARRAY,"name":"portraits","usage":default_usage, "hint":24, "hint_string":"17/17:Resource"})
	return p


func _set_portraits(value:Array) -> void:
	for item in portraits:
		item = item as Resource
		if item == null:
			continue
		if item.is_connected("changed", self, "emit_changed"):
			item.disconnect("changed", self, "emit_changed")
	
	portraits = value.duplicate()

	for item in portraits:
		item = item as Resource
		if item == null:
			continue
		if not item.is_connected("changed", self, "emit_changed"):
			item.connect("changed", self, "emit_changed")
	
	emit_changed()
	property_list_changed_notify()


func _get(property: String):
	if property == "portraits_number":
		return portraits.size()


func _hide_script_from_inspector():
	return true


func property_can_revert(property:String) -> bool:
	var _r_p = ["display_name", "blip_sounds", "portraits"]
	return property in _r_p


func property_get_revert(property:String):
	match property:
		"display_name":
			return ""
		"blip_sounds", "portraits":
			return []
