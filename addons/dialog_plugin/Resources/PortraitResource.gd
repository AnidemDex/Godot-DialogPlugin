tool
extends Resource
class_name DialogPortraitResource

export(String) var name:String = "" setget _set_name
export(Texture) var image:Texture = null
export(Texture) var icon:Texture = null

func _set_name(value:String) -> void:
	name = value
	resource_name = value
