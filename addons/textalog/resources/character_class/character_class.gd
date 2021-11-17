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
export(String) var name:String = "" setget set_name

## Name of the character that'll be displayed in game. By default, is the same as name
export(String) var display_name:String = "" setget set_display_name,get_display_name

## Color of the character name
export(Color) var color:Color = Color.white setget set_color

## Character icon. Used by the editor.
export(Texture) var icon:Texture = null setget set_icon

## Character sounds when talking.
var blip_sounds:Array = []

## Collection of portraits that'll be displayed in game
var portraits:Array = []

func _init() -> void:
	portraits = []
	blip_sounds = []


## Adds a [DialogPortraitResource] in [member portraits]
func add_portrait(portrait) -> void:
	if not portrait in portraits:
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
		portraits.erase(portrait)
		emit_changed()



## Removes a [AudioStream] from [member blip_sounds]
func remove_blip_sound(blip_sound:AudioStream) -> void:
	if blip_sound in blip_sounds:
		blip_sounds.erase(blip_sound)
		emit_changed()


func set_name(value:String) -> void:
	name = value
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


func get_display_name() -> String:
	if display_name:
		return display_name
	else:
		return name


func _get_property_list() -> Array:
	var properties:Array = []
	properties.append(
		{
			"name":"portraits",
			"type":TYPE_ARRAY,
			"usage":PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_NOEDITOR,
		}
		)
	properties.append(
		{
			"name":"blip_sounds",
			"type":TYPE_ARRAY,
			"usage":PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_NOEDITOR,
		}
	)
	return properties


func _get(property: String):
	if property == "portraits_number":
		return portraits.size()
