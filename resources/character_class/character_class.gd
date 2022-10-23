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

const _Portrait = preload("res://addons/textalog/resources/portrait_class/portrait_class.gd")

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
var blip_sounds = null setget _set_blip_sounds

var _portrait_data:Dictionary = {"default":_Portrait.new()}


## Adds a [DialogPortraitResource] in [member portraits]
func add_portrait(portrait:String, texture:Texture) -> void:
	pass


## Removes a [DialogPortraitResource] from [member portraits]
func remove_portrait(portrait:String, texture:Texture) -> void:
	pass


func set_name(value:String) -> void:
	name = value
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
	p.append({"type":TYPE_OBJECT, "name":"blip_sounds", "usage":default_usage, "hint":24, "hint_string":"17/17:AudioStream"})
	
	p.append({"type":TYPE_NIL, "name":"Portraits", "usage":PROPERTY_USAGE_CATEGORY})
	for key in _portrait_data:
		p.append({"type":TYPE_OBJECT, "name":"portrait/"+key, "usage":default_usage})
	
	return p


func _get(property: String):
	if property == "portraits":
		return PoolStringArray(_portrait_data.keys())
	
	if property.begins_with("portrait/"):
		var p:String = property.trim_prefix("portrait/")
		if p in _portrait_data:
			return _portrait_data[p]


func _hide_script_from_inspector():
	return true


func property_can_revert(property:String) -> bool:
	var _r_p = ["display_name", "blip_sounds", "portraits"]
	return property in _r_p


func property_get_revert(property:String):
	match property:
		"display_name":
			return ""

func _init() -> void:
	_portrait_data = {"default":_Portrait.new()}
