tool
extends Resource
class_name DialogCharacterResource

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")

export(String) var name:String = "" setget set_name
export(String) var display_name:String setget set_display_name,get_display_name
export(Color) var color:Color = Color.white setget set_color
export(Texture) var icon:Texture = null setget set_icon
var blip_sounds:Array = []
var portraits:Array = []

func add_portrait(portrait:DialogPortraitResource) -> void:
	if not portrait in portraits:
		portraits.append(portrait)
		emit_changed()


func add_blip_sound(blip_sound:AudioStream) -> void:
	if not blip_sound in blip_sounds:
		blip_sounds.append(blip_sound)
		emit_changed()


func remove_portrait(portrait:DialogPortraitResource) -> void:
	if portrait in portraits:
		portraits.erase(portrait)
		emit_changed()



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
	var portrait_hint:Dictionary = DialogUtil.get_property_dict("portraits_number", TYPE_INT, PROPERTY_HINT_NONE, "", PROPERTY_USAGE_NO_INSTANCE_STATE | PROPERTY_USAGE_EDITOR)
	var portraits_property:Dictionary = DialogUtil.get_property_dict("portraits", TYPE_ARRAY, PROPERTY_HINT_NONE, "", PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_NOEDITOR)
	properties.append(portrait_hint)
	properties.append(portraits_property)
	return properties


func _get(property: String):
	if property == "portraits_number":
		return portraits.size()
