extends PortraitManager

export var character_folder:String

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
	
	# Remove previous node
	if character in portraits:
		remove_portrait(character)
		emit_signal("portrait_changed", character, portrait)
	
	var _node:Control

	var path = character_folder + character.name + ".tscn"
	if ResourceLoader.exists(path):
		_node = load(path).instance()
	else:
		_node = TextureRect.new()
	connect("tree_exiting", _node, "queue_free")
	
	if character.display_name:
		_node.name = character.display_name
	
	portraits[character] = _node
	
	# Focus and _input
	_node.mouse_filter = MOUSE_FILTER_IGNORE
	_node.focus_mode = Control.FOCUS_NONE
	
	add_child(_node)
	
	# I know that I can iterate over property list to copy property values
	# but i want to keep the control over this section here
	
	# Node configuration to resize according the screen
	_node.anchor_left = 0
	_node.anchor_top = 0
	_node.anchor_right = 1
	_node.anchor_bottom = 1
	
	
	# Size
	var ignore_ref_size:bool = rect_data.get("ignore_reference_size", false)
	var ref_size:Vector2 = reference_rect.rect_size
	if ignore_ref_size:
		var _rel_size:Vector2 = rect_data.get("size", Vector2(0.3, 0.7))
		ref_size = _get_relative_position(_rel_size)
		ref_size.x = max(ref_size.x, 0)
		ref_size.y = max(ref_size.y, 0)
	_node.rect_size = ref_size
	
	# Position
	var ignore_ref_pos:bool = rect_data.get("ignore_reference_position", false)
	var ref_position:Vector2 = reference_rect.rect_position
	if ignore_ref_pos:
		var _rel_pos:Vector2 = rect_data.get("position", Vector2(0.35,0.2))
		ref_position = _get_relative_position(_rel_pos)
	_node.rect_position = ref_position
	_node.rect_pivot_offset = _node.rect_size/2
	
	# Rotation
	var ignore_ref_rot:bool = rect_data.get("ignore_reference_rotation", false)
	var ref_rotation = reference_rect.rect_rotation
	if ignore_ref_rot:
		ref_rotation = rect_data.get("rotation", 0.0)
	_node.rect_rotation = ref_rotation
	
	# TextureRect
	if _node is TextureRect:
		_node.expand = texture_data.get("expand", true)
		_node.stretch_mode = texture_data.get("stretch_mode", TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		_node.flip_h = texture_data.get("flip_h", false)
		_node.flip_v = texture_data.get("flip_v", false)
	else:
		# TODO: call appropriate functions on the character script.
		pass
	
	if _node.has_method("change_expression"):
		_node.change_expression(portrait.name)
	else:
		_node.texture = portrait.image

	_node.raise()
	
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


func change_portrait(character:Character, portrait:Portrait) -> void:
	if not character or not portrait:
		emit_signal("portrait_changed", character, portrait)
		return
	
	if not character in portraits:
		add_portrait(character, portrait)
		return
	
	if portraits[character].has_method("change_expression"):
		portraits[character].change_expression(portrait.name)
	else:
		portraits[character].texture = portrait.image
	portraits[character].raise()
	emit_signal("portrait_changed", character, portrait)
