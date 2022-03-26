tool
extends "res://addons/textalog/events/character/char_event.gd"
class_name EventCharacterJoin
export(bool) var remove_other_portraits = false
var rect_ignore_reference_size := false setget ignore_reference_size
var rect_ignore_reference_position := false setget ignore_reference_position
var rect_ignore_reference_rotation := false setget ignore_reference_rotation
var rect_percent_position := Vector2() setget set_percent_position
var rect_percent_size := Vector2() setget set_percent_size
var rect_rotation := 0.0 setget set_rotation

var texture_expand:bool = true setget set_expand
var texture_stretch_mode:int = TextureRect.STRETCH_KEEP_ASPECT_CENTERED setget set_stretch_mode
var texture_flip_h:bool = false setget set_flip_h
var texture_flip_v:bool = false setget set_flip_v

func _init() -> void:
	event_name = "Join"
	event_hint = "Make a character portrait joins in the scene."
	event_preview_string = "[{character_name}] will join with portrait [{expression_name}] at position [ {position_hint} ]"
	event_icon = load("res://addons/textalog/assets/icons/event_icons/character_join.png") as Texture


func _execute() -> void:
	var node = get_event_node() as DialogNode
	if not is_instance_valid(node):
		finish()
		return
	
	var portrait_manager:PortraitManager = node.portrait_manager
	
	if not is_instance_valid(portrait_manager):
		finish()
		return
	
	node.visible = true
	portrait_manager.visible = true
	
	portrait_manager.connect("portrait_added", self, "_on_portrait_added", [], CONNECT_ONESHOT)
	
	var rect_data := {
		"ignore_reference_size":rect_ignore_reference_size,
		"ignore_reference_position":rect_ignore_reference_position,
		"ignore_reference_rotation":rect_ignore_reference_rotation,
		"size":rect_percent_size,
		"position":rect_percent_position,
		"rotation":rect_rotation
	}
	
	var texture_data := {
		"expand":texture_expand,
		"stretch_mode":texture_stretch_mode,
		"flip_h":texture_flip_h,
		"flip_v":texture_flip_v
	}
	
	var args := [
		character,
		get_selected_portrait(),
		rect_data,
		texture_data
	]
	
	if remove_other_portraits:
		portrait_manager.remove_all_other_portraits(character)
	
	portrait_manager.call_deferred("callv", "add_portrait", args)


func ignore_reference_size(value:bool) -> void:
	rect_ignore_reference_size = value
	emit_changed()
	property_list_changed_notify()


func ignore_reference_position(value:bool) -> void:
	rect_ignore_reference_position = value
	emit_changed()
	property_list_changed_notify()


func ignore_reference_rotation(value:bool) -> void:
	rect_ignore_reference_rotation = value
	emit_changed()
	property_list_changed_notify()

func set_percent_position(value:Vector2) -> void:
	rect_percent_position = value
	emit_changed()


func set_percent_size(value:Vector2) -> void:
	rect_percent_size = value
	emit_changed()


func set_rotation(value:float) -> void:
	rect_rotation = value
	emit_changed()


func set_expand(value:bool) -> void:
	texture_expand = value
	emit_changed()


func set_stretch_mode(value:int) -> void:
	texture_stretch_mode = value
	emit_changed()


func set_flip_h(value:bool) -> void:
	texture_flip_h = value
	emit_changed()


func set_flip_v(value:bool) -> void:
	texture_flip_v = value
	emit_changed()


func _on_portrait_added(_c, _p) -> void:
	finish()


func _get(property: String):
	if property == "position_hint":
		if not rect_ignore_reference_position:
			return "same as reference rect"
		return str(rect_percent_position)


func _get_property_list() -> Array:
	var p := []
	var usage:int = PROPERTY_USAGE_SCRIPT_VARIABLE|PROPERTY_USAGE_DEFAULT
	p.append({"type":TYPE_STRING, "name":"position_hint", "usage":0})
	
	# Rect
	p.append({"type":TYPE_NIL, "name":"Rect Options", "usage":PROPERTY_USAGE_GROUP, "hint_string":"rect_"})

	p.append({"type":TYPE_BOOL, "name":"rect_ignore_reference_size", "usage":usage})
	if rect_ignore_reference_size:
		p.append({"type":TYPE_VECTOR2, "name":"rect_percent_size", "usage":usage})
	
	p.append({"type":TYPE_BOOL, "name":"rect_ignore_reference_position", "usage":usage})
	if rect_ignore_reference_position:
		p.append({"type":TYPE_VECTOR2, "name":"rect_percent_position", "usage":usage})
	
	p.append({"type":TYPE_BOOL, "name":"rect_ignore_reference_rotation", "usage":usage})
	if rect_ignore_reference_rotation:
		p.append({"type":TYPE_REAL, "name":"rect_rotation", "usage":usage, "hint":PROPERTY_HINT_RANGE, "hint_string":"-360,360,1,"})
	
	#Texture
	p.append({"type":TYPE_NIL, "name":"Texture", "usage":PROPERTY_USAGE_GROUP, "hint_string":"texture_"})
	p.append({"type":TYPE_BOOL, "name":"texture_expand", "usage":usage})
	
	var stretch_enum := str(ClassDB.class_get_enum_constants("TextureRect", "StretchMode")).replace("[","").replace("]","")
	stretch_enum = stretch_enum.replace("STRETCH_","")
	stretch_enum = stretch_enum.capitalize()
	
	p.append({"type":TYPE_INT, "name":"texture_stretch_mode", "usage":usage, "hint":PROPERTY_HINT_ENUM, "hint_string":stretch_enum})
	
	p.append({"type":TYPE_BOOL, "name":"texture_flip_h", "usage":usage})
	p.append({"type":TYPE_BOOL, "name":"texture_flip_v", "usage":usage})
	
	return p
