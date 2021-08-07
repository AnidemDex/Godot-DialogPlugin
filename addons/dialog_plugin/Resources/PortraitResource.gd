tool
extends Resource
class_name DialogPortraitResource

export(String) var name:String = "" setget _set_name
export(Texture) var image:Texture = null
export(Texture) var icon:Texture = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/character/change_expression.png") as Texture

func _set_name(value:String) -> void:
	name = value
	resource_name = value
