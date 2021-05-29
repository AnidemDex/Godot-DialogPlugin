tool
class_name DialogPortraitManager
extends Control

signal portrait_added(character, new_portrait)
signal portrait_changed(character, new_portrait)
signal portrait_removed(character, portrait)

export(NodePath) var ReferenceSize:NodePath

onready var size_reference_node:Control = get_node(ReferenceSize) as Control

# {CharacterResource: PortraitNode(TextureRect)}
var portraits:Dictionary = {}

func add_portrait(
	character:DialogCharacterResource,
	portrait:DialogPortraitResource,
	relative_position:Vector2=Vector2(0.414,0.275)
	) -> void:
	
	if not character or portrait:
		emit_signal("portrait_added", character, portrait)
		return
	
	# Remove previous node
	if character in portraits:
		portraits[character].queue_free()
		portraits[character] = null
	
	var _texture_rect:TextureRect = TextureRect.new()
	_texture_rect.texture = portrait.image
	_texture_rect.name = character.display_name
	
	# Size behaviour
	_texture_rect.expand = true
	_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_texture_rect.rect_size = size_reference_node.rect_size
	
	# Focus and _input
	_texture_rect.mouse_filter = MOUSE_FILTER_IGNORE
	_texture_rect.focus_mode = Control.FOCUS_NONE
	
	add_child(_texture_rect)
	
	# I know that I can iterate over property list to copy property values
	# but i want to keep the control over this section here
	
	# Node configuration to resize according the screen
	_texture_rect.anchor_left = size_reference_node.anchor_left
	_texture_rect.anchor_top = size_reference_node.anchor_top
	_texture_rect.anchor_right = size_reference_node.anchor_right
	_texture_rect.anchor_bottom = size_reference_node.anchor_bottom
	
	var _position:Vector2 = Vector2()
	_position.x = float(lerp(0, rect_size.x, relative_position.x))
	_position.y = float(lerp(0, rect_size.y, relative_position.y))
	
	_texture_rect.rect_position = _position
	_texture_rect.rect_pivot_offset = _position/2
	
	# Rotation
	_texture_rect.rect_rotation = 0
	
	grab_portrait_focus(_texture_rect)
	


func remove_portrait(portrait_node:Node) -> void:
	portrait_node.queue_free()


func grab_portrait_focus(char_portrait_node:TextureRect) -> void:
	char_portrait_node.raise()
