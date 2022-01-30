tool
extends Control
class_name PortraitManager

##
## Base class for any DialogPortraitManager node.
##
## @desc:
##     Manages the displayed portrait of any character, saving their reference.
##
## @tutorial(Online Documentation): https://anidemdex.gitbook.io/godot-dialog-plugin/documentation/node-class/class_dialog-portrait-manager
##

## Emmited when a character portrait was added.
signal portrait_added(character, new_portrait)

## Emmited when a [Class Portrait] was changed with a new one.
signal portrait_changed(character, new_portrait)

## Emmited when a character portrait was removed from scene.
signal portrait_removed(character)

export(Vector2) var preview_relative_position := Vector2(0.35,0.2) setget _set_preview_relative_position
export(Vector2) var preview_relative_size := Vector2(0.3, 0.7) setget _set_preview_relative_size

var reference_rect:ReferenceRect

# {CharacterResource: PortraitNode(TextureRect)}
var portraits:Dictionary = {}

## Adds a portrait for character to the scene
func add_portrait(
	character:Character,
	portrait:Portrait,
	rect_data:Dictionary = {},
	texture_data:Dictionary = {}
	) -> void:
	
	if (not character) or (not portrait):
		emit_signal("portrait_added", character, portrait)
		return
	
	
	var _texture_rect:TextureRect

	# Use previous node as reference
	if character in portraits:
		_texture_rect = portraits.get(character, null)
	# Create a new node as no previous node exists
	if not is_instance_valid(_texture_rect):
		_texture_rect = TextureRect.new()
		portraits[character] = _texture_rect

	if not is_connected("tree_exiting", _texture_rect, "queue_free"):
		connect("tree_exiting", _texture_rect, "queue_free")
	
	if character.display_name:
		_texture_rect.name = character.display_name
	
	# Focus and _input
	_texture_rect.mouse_filter = MOUSE_FILTER_IGNORE
	_texture_rect.focus_mode = Control.FOCUS_NONE
	
	if _texture_rect.get_parent():
		_texture_rect.get_parent().remove_child(_texture_rect)
	add_child(_texture_rect)
	
	# I know that I can iterate over property list to copy property values
	# but i want to keep the control over this section here
	
	# Node configuration to resize according the screen
	_texture_rect.anchor_left = 0
	_texture_rect.anchor_top = 0
	_texture_rect.anchor_right = 1
	_texture_rect.anchor_bottom = 1
	
	
	# Size
	var ignore_ref_size:bool = rect_data.get("ignore_reference_size", false)
	var ref_size:Vector2 = reference_rect.rect_size
	if ignore_ref_size:
		var _rel_size:Vector2 = rect_data.get("size", Vector2(0.3, 0.7))
		ref_size = _get_relative_position(_rel_size)
		ref_size.x = max(ref_size.x, 0)
		ref_size.y = max(ref_size.y, 0)
	_texture_rect.rect_size = ref_size
	
	# Position
	var ignore_ref_pos:bool = rect_data.get("ignore_reference_position", false)
	var ref_position:Vector2 = reference_rect.rect_position
	if ignore_ref_pos:
		var _rel_pos:Vector2 = rect_data.get("position", Vector2(0.35,0.2))
		ref_position = _get_relative_position(_rel_pos)
	_texture_rect.rect_position = ref_position
	_texture_rect.rect_pivot_offset = _texture_rect.rect_size/2
	
	# Rotation
	var ignore_ref_rot:bool = rect_data.get("ignore_reference_rotation", false)
	var ref_rotation = reference_rect.rect_rotation
	if ignore_ref_rot:
		ref_rotation = rect_data.get("rotation", 0.0)
	_texture_rect.rect_rotation = ref_rotation
	
	# TextureRect
	_texture_rect.expand = texture_data.get("expand", true)
	_texture_rect.stretch_mode = texture_data.get("stretch_mode", TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	_texture_rect.flip_h = texture_data.get("flip_h", false)
	_texture_rect.flip_v = texture_data.get("flip_v", false)
	
	_texture_rect.texture = portrait.image
	
	grab_portrait_focus(_texture_rect)
	
	emit_signal("portrait_added", character, portrait)
		


func remove_portrait(character:Character) -> void:
	if character:
		var _old_p = portraits.get(character, null)
		if _old_p != null:
			_old_p.queue_free()
		portraits.erase(character)
	
	emit_signal("portrait_removed", character)


func remove_all_portraits() -> void:
	for character in portraits.keys():
		remove_portrait(character)


func remove_all_other_portraits(character:Character) -> void:
	for _character in portraits.keys():
		if _character == character:
			continue
		remove_portrait(_character)


func change_portrait(character:Character, portrait:Portrait) -> void:
	if not character or not portrait:
		emit_signal("portrait_changed", character, portrait)
		return
	
	if not character in portraits:
		add_portrait(character, portrait)
		return
	
	portraits[character].texture = portrait.image
	grab_portrait_focus(portraits[character])
	emit_signal("portrait_changed", character, portrait)


func grab_portrait_focus(char_portrait_node:TextureRect) -> void:
	char_portrait_node.raise()


##########
# Private things
##########

func _get_relative_position(from:Vector2) -> Vector2:
	var _position:Vector2 = Vector2()
	_position.x = float(lerp(0, rect_size.x, from.x))
	_position.y = float(lerp(0, rect_size.y, from.y))
	return _position


func _set_preview_relative_position(value:Vector2) -> void:
	preview_relative_position = value
	
	if not is_instance_valid(reference_rect):
		return
	
	var _relative_position := _get_relative_position(preview_relative_position)	
	reference_rect.rect_position = _relative_position


func _set_preview_relative_size(value:Vector2) -> void:
	preview_relative_size = value
	
	if not is_instance_valid(reference_rect):
		return
	
	var _relative_size := _get_relative_position(preview_relative_size)
	reference_rect.rect_size = _relative_size


func _init() -> void:
	reference_rect = ReferenceRect.new()
	reference_rect.anchor_left = 0
	reference_rect.anchor_top = 0
	reference_rect.anchor_right = 1
	reference_rect.anchor_bottom = 1
	reference_rect.grow_horizontal = Control.GROW_DIRECTION_BOTH
	reference_rect.grow_vertical = Control.GROW_DIRECTION_BOTH
	add_child(reference_rect)


func _notification(what) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			if is_instance_valid(reference_rect):
				reference_rect.queue_free()
		NOTIFICATION_RESIZED:
#			var _relative_size := _get_relative_position(preview_relative_size)
#			var _relative_position := _get_relative_position(preview_relative_position)
#			printt(preview_relative_position, preview_relative_size, _relative_position, _relative_size, rect_size)
#			reference_rect.rect_size = _relative_size
#			reference_rect.rect_position = _relative_position
			set("preview_relative_position", preview_relative_position)
			set("preview_relative_size", preview_relative_size)
