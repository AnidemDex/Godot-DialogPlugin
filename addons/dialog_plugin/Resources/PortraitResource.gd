tool
extends Resource
class_name DialogPortraitResource, "res://addons/dialog_plugin/assets/Images/icons/portrait_icon.png"

##
## Resource that holds textures to be used in game for each character expression.
##

## Name of the expression.
export(String) var name:String = "" setget _set_name

## Optional texture to be used in game.
export(Texture) var image:Texture = null

## Optional icon to be used in the editor
export(Texture) var icon:Texture = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/character/change_expression.png") as Texture

func _set_name(value:String) -> void:
	name = value
	resource_name = value
