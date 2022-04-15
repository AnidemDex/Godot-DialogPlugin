tool
extends Event

##
## Character event class
##
enum Mode {NONE=-1, JOIN, LEAVE, CHANGE_EXPRESSION}
## Event mode
export(Mode) var mode:int = Mode.NONE setget set_mode

## The character used for this event.
var character:Character = null setget set_character

## The portrait index selected for this event.
var selected_portrait:int = -1 setget set_selected_portrait

export(bool) var remove_all_portraits = false
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
	event_color = Color("4CB963")
	event_category = "Character"
	event_name = "Character"


var portrait_manager:PortraitManager
func _execute() -> void:
	var node:DialogNode = get_event_node() as DialogNode
	if not is_instance_valid(node):
		finish()
		return
	
	portrait_manager = node.portrait_manager
	
	if not is_instance_valid(portrait_manager):
		finish()
		return
	
	node.visible = true
	portrait_manager.visible = true
	
	
	match mode:
		Mode.NONE:
			if remove_all_portraits:
				portrait_manager.remove_all_portraits()
			finish()
		Mode.JOIN, Mode.LEAVE:
			
			if remove_other_portraits:
				portrait_manager.remove_all_other_portraits(character)
			
			if mode == Mode.JOIN:
				_join()
			
			if mode == Mode.LEAVE:
				_leave()
		
		Mode.CHANGE_EXPRESSION:
			_change_expression()


func set_mode(value:int) -> void:
	mode = value
	match mode:
		Mode.JOIN:
			event_name = "Character Join"
			event_hint = "Make a character portrait joins in the scene."
			event_preview_string = "[{character_name}] will join with portrait [{expression_name}] at position [ {position_hint} ]"
			event_icon = load("res://addons/textalog/assets/icons/event_icons/character_join.png") as Texture
			
		Mode.LEAVE:
			event_name = "Character Leave"
			event_hint = "Make a character portrait leaves the scene."
			event_preview_string = "[{character_name}] will leave the scene"
			event_icon = load("res://addons/textalog/assets/icons/event_icons/character_leave.png") as Texture
		
		Mode.NONE:
			event_name = "Character"
			event_hint = "An event related to character instructions. It makes the character joins or leaves the scene."
			event_preview_string = ""
		
		Mode.CHANGE_EXPRESSION:
			event_name = "Change expression"
			event_hint = "Changes the portrait of the character"
			event_preview_string = "[{character_name}] expression will be [{expression_name}]"
			event_icon = load("res://addons/textalog/assets/icons/event_icons/change_expression.png") as Texture
	
	emit_changed()
	property_list_changed_notify()

## Returns the portrait selected according to selected_portrait or null if none is selected.
func get_selected_portrait() -> Portrait:
	var _selected_portrait:Portrait = null
	if character and selected_portrait != -1:
		_selected_portrait = character.portraits[selected_portrait]
	return _selected_portrait


func set_character(value:Character) -> void:
	character = value
	emit_changed()
	property_list_changed_notify()


func set_selected_portrait(value:int) -> void:
	selected_portrait = value
	emit_changed()
	property_list_changed_notify()


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


func _join() -> void:
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
	
	portrait_manager.call_deferred("callv", "add_portrait", args)


func _leave() -> void:
	portrait_manager.connect("portrait_removed", self, "_on_portrait_removed", [], CONNECT_ONESHOT)
	
	portrait_manager.remove_portrait(character)


func _change_expression() -> void:
	portrait_manager.connect("portrait_changed", self, "_on_portrait_changed", [], CONNECT_ONESHOT)
	
	portrait_manager.change_portrait(character, get_selected_portrait())


func _on_portrait_added(_c, _p) -> void:
	finish()


func _on_portrait_removed(_c) -> void:
	finish()


func _on_portrait_changed(_c, _p) -> void:
	finish()


func _get(property: String):
	if property == "character_name":
		if character:
			return character.display_name
		else:
			return "???"
	
	if property == "expression_name":
		var xpsn := get_selected_portrait()
		if xpsn:
			return xpsn.get("name")
		else:
			return "???"
	
	match mode:
		Mode.NONE:
			if property == "character_ignore":
				return true
			if property == "remove_other_portraits_ignore":
				return true
			continue
		
		Mode.NONE, Mode.LEAVE:
			if property == "selected_portrait_ignore":
				return true
			continue
		
		Mode.JOIN, Mode.LEAVE, Mode.CHANGE_EXPRESSION:
			if property == "remove_all_portraits_ignore":
				return true
			continue
		
		Mode.CHANGE_EXPRESSION:
			if property == "remove_other_portraits_ignore":
				return true
	
	if property == "event_node_path_ignore":
		return true
		

func _get_property_list() -> Array:
	var p := []
	var default_usage := PROPERTY_USAGE_DEFAULT|PROPERTY_USAGE_SCRIPT_VARIABLE
	p.append({"type":TYPE_STRING,"name":"character_name", "usage":0})
	p.append({"type":TYPE_STRING, "name":"expression_name", "usage":0})
	p.append({"type":TYPE_OBJECT, "name":"character", "usage":default_usage, "hint":PROPERTY_HINT_RESOURCE_TYPE, "hint_string":"Resource"})
	
	if not get("selected_portrait_ignore"):
		var portraits_hint = "[None]:-1"
		# haha for loops goes brrrr~
		if character:
			for portrait_idx in character.portraits.size():
				var portrait = character.portraits[portrait_idx] as Portrait
				if portrait == null:
					continue
				portraits_hint += ","+portrait.name + ":%s"%portrait_idx
			
		p.append({"type":TYPE_INT, "name":"selected_portrait", "usage":default_usage, "hint":PROPERTY_HINT_ENUM, "hint_string":portraits_hint})
		
		match mode:
			Mode.JOIN:
				p.append_array(_get_join_property_list())
			Mode.LEAVE:
				pass
			Mode.NONE:
				pass
	return p


func _get_join_property_list() -> Array:
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
