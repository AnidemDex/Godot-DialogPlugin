extends Resource
class_name Portrait, "res://addons/textalog/assets/icons/portrait_icon.png"

##
## Resource that holds textures to be used in game for each character expression.
##

## Name of the expression.
export(String) var name:String = "" setget _set_name

## Optional texture to be used in game.
export(Texture) var image:Texture = null setget set_image

## Optional icon to be used in the editor
export(Texture) var icon:Texture = null setget _set_icon


func set_image(value:Texture) -> void:
	image = value
	emit_changed()
	property_list_changed_notify()


func _set_icon(value:Texture) -> void:
	icon = value
	emit_changed()
	property_list_changed_notify()


func _set_name(value:String) -> void:
	name = value
	resource_name = value
	emit_changed()
	property_list_changed_notify()
