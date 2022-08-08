extends Resource
class_name Portrait, "res://addons/textalog/assets/icons/portrait_icon.png"

##
## Resource that holds textures to be used in game for each character expression.
##

## Optional texture to be used in game.
export(Texture) var texture:Texture = null setget set_image

## Optional icon to be used in the editor
export(Texture) var icon:Texture = load("res://addons/textalog/assets/icons/event_icons/change_expression.png") setget _set_icon


func set_image(value:Texture) -> void:
	texture = value
	emit_changed()
	property_list_changed_notify()


func _set_icon(value:Texture) -> void:
	icon = value
	emit_changed()
	property_list_changed_notify()


func _hide_script_from_inspector():
	return true
