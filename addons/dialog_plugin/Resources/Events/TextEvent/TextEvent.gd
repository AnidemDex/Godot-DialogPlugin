tool
class_name DialogTextEvent
extends DialogEventResource

const SAME_AS_TEXT = "__SAME_AS_TEXT__"

# https://github.com/godotengine/godot/pull/37324
const EventTimer = preload("res://addons/dialog_plugin/Resources/Events/TextEvent/TextEventTimer.gd")

export(String, MULTILINE) var text:String = ""
export(float, 0.01, 1.0, 0.01) var text_speed:float = 0.02
export(bool) var continue_previous_text:bool = false
export(String) var translation_key = SAME_AS_TEXT

var character:DialogCharacterResource = null setget set_character

var font_normal:Font = null
var font_bold:Font = null
var font_italics:Font = null
var font_bold_italics:Font = null


var _timer:EventTimer = null
var _DialogNode:DialogDialogueNode = null


func _init():
	resource_name = "TextEvent"
	event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/text_event_node/text_event_node.tscn"


func execute(caller:DialogBaseNode) -> void:
	.execute(caller)
	
	_DialogNode = caller.DialogNode
	
	configure_timer()

	caller.visible = true
	if _DialogNode:
		prepare_text()
		prepare_character_name()
		_DialogNode.visible = true
		
	
	_timer.start(text_speed)


func configure_timer() -> void:
	if not is_instance_valid(_timer):
		_timer = EventTimer.new()
		_caller.add_child(_timer)
	_timer.caller = _caller
	
	if not _timer.is_connected("timeout", self, "_on_TextTimer_timeout"):
		var _err:int = _timer.connect("timeout", self, "_on_TextTimer_timeout")
		assert(_err == OK)


func remove_timer() -> void:
	if is_instance_valid(_timer):
		_timer.stop()
		_timer.queue_free()


func prepare_text() -> void:
	var text_node:RichTextLabel = _DialogNode.TextNode
	if not text_node:
		finish(true)
		return
	
	configure_text_node_fonts(text_node)
	
	var _variables:Dictionary = load(VARIABLES_PATH).variables
	var final_text = text.format(_variables)
	
	if continue_previous_text:
		text_node.append_bbcode(text)
	else:
		text_node.bbcode_text = text.format(_variables)
		text_node.visible_characters = 0


func configure_text_node_fonts(text_node:RichTextLabel) -> void:
	if font_normal:
		text_node.add_font_override("normal_font", font_normal)
	if font_bold:
		text_node.add_font_override("bold_font", font_bold)
	if font_italics:
		text_node.add_font_override("italics_font", font_italics)
	if font_bold_italics:
		text_node.add_font_override("bold_italics_font", font_bold_italics)


func prepare_character_name() -> void:
	if not character:
		return
	
	var name_node:Label = _DialogNode.NameNode
	if not name_node:
		return
	
	name_node.visible = false if character.name == "" else true
	name_node.text = character.display_name
	name_node.add_color_override("font_color", character.color)


func _update_text() -> void:
	if not _DialogNode:
		finish(true)
		return
	
	var text_node:RichTextLabel = _DialogNode.TextNode
	
	text_node.visible_characters += 1
	
	if text_node.visible_characters < text_node.get_total_character_count():
		_timer.start(text_speed)
	else:
		remove_timer()
		finish()


func set_character(value:DialogCharacterResource) -> void:
	character = null
	if (value is DialogCharacterResource) or (value == null):
		character = value
		property_list_changed_notify()
		return
	printerr("Can't assing another type of resource to character")
	property_list_changed_notify()


func _on_TextTimer_timeout():
	_update_text()


# Export stuff
# DO NOT MODIFY ANYTHING HERE

func _get_property_list() -> Array:
	var _p:Array = []
	
	var character_property := DialogUtil.get_property_dict("character", TYPE_OBJECT, PROPERTY_HINT_RESOURCE_TYPE, "DialogCharacterResource", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE) 
	var font_category := DialogUtil.get_property_dict("Custom Fonts", TYPE_NIL, PROPERTY_HINT_NONE, "font_", PROPERTY_USAGE_GROUP)
	var font_normal_property := DialogUtil.get_property_dict("font_normal", TYPE_OBJECT, PROPERTY_HINT_RESOURCE_TYPE, "Font", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE)
	var font_bold_property := DialogUtil.get_property_dict("font_bold", TYPE_OBJECT, PROPERTY_HINT_RESOURCE_TYPE, "Font", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE)
	var font_italics_property := DialogUtil.get_property_dict("font_italics", TYPE_OBJECT, PROPERTY_HINT_RESOURCE_TYPE, "Font", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE)
	var font_bold_italics_property := DialogUtil.get_property_dict("font_bold_italics", TYPE_OBJECT, PROPERTY_HINT_RESOURCE_TYPE, "Font", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE)
	_p.append_array([character_property, font_category, font_normal_property, font_bold_property, font_italics_property, font_bold_italics_property])
	return _p

