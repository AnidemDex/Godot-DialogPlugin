tool
extends Container
class_name DialogManager

## 
## Base class for all dialogue nodes.
##
## @desc:
##     This node takes cares about displaying text and showing an indicator.
##
## @tutorial(Online Documentation): https://anidemdex.gitbook.io/godot-dialog-plugin/documentation/node-class/class_dialog-dialogue-node
##

## Anchor points that the bubble can take as reference
enum BubblePosition {CENTER_LEFT,CENTER_RIGHT,CENTER_TOP,CENTER_DOWN}
enum BlipStrategy {NO_BLIP, BLIP_ONCE, BLIP_LOOP}

## Emmited when the text is fully displayed
signal text_displayed
## Emmited eveytime that a character is displayed
signal character_displayed(character)

## The speed that the node uses to wait before adding another character.
## Values between 0.02 and 0.08 are good ones to use.
export(float) var text_speed:float = 0.02
## If true, DialogManager will try to scroll the text to fit new content
export(bool) var text_autoscroll:bool = false
## If true and [member text_autoscroll] is false, DialogManager will scale its size
## to fit its content.
export(bool) var text_fit_content_height:bool = false
## If true, DialogManager will show an VScroll to scroll its content
export(bool) var text_show_scroll_at_end:bool = true
## The [member BubblePosition] that the bubble will take as reference point.
export(BubblePosition) var bubble_anchor:int = BubblePosition.CENTER_DOWN setget _set_bubble_anchor
## Offset of the bubble relative to the selected [member bubble_anchor]
export(Vector2) var bubble_offset:Vector2 = Vector2() setget _set_bubble_offset

## The node that actually displays the text
var text_node:RichTextLabel setget ,get_text_node
var _text_timer:Timer


## Calling this method will make to all text to be visible inmediatly
func display_all_text() -> void:
	if text_node.visible_characters >= text_node.get_total_character_count():
		return
	text_node.visible_characters = text_node.get_total_character_count() -1
	_char_position = text_node.visible_characters
	_update_displayed_text() 


## Starts displaying the text setted by [method set_text]
func display_text() -> void:
	_text_timer.start(text_speed)


## Set the text that this node will display. Call [method display_text]
## after using this method to display the text.
func set_text(text:String) -> void:
	text_node.bbcode_text = text
	text_node.visible_characters = 0
	_char_position = 0
	rect_min_size = _original_size
	if text_fit_content_height:
		_enable_fit_content_height()
	
	_line_count = -1
	_last_line_count = 0
	_last_wordwrap_size = Vector2()
	text_node.get_v_scroll().value = 0


## Adds text to the current one at the end. No need to call
## [method display_text] if the node is already displaying text
func add_text(text:String) -> void:
	text_node.bbcode_text = text_node.bbcode_text + text


## Returns the used text_node
func get_text_node() -> RichTextLabel:
	if is_instance_valid(text_node):
		return text_node
	return null


func set_blip_strategy(strategy:int) -> void:
	_blip_strategy = clamp(strategy, 0, BlipStrategy.size()-1)


## Set the blip samples that'll be used on blip
func set_blip_samples(samples:Array) -> void:
	_blip_samples = samples.duplicate()


func set_blip_space_samples(samples:Array) -> void:
	_blip_space_samples = samples.duplicate()


func set_audio_bus(bus:String) -> void:
	_blip_bus = bus


func set_blip_rate(value:int) -> void:
	_blip_rate = max(1, value)


func force_blip(value:bool) -> void:
	_blip_force = value


func map_blip_to_letter(value:bool) -> void:
	_blip_map = value


func get_blip_sample(for_char:String="") -> AudioStream:
	var blip_sample:AudioStream
	if _blip_samples.empty():
		return null
	
	if _blip_map:
		
		pass
	var _limit = max(_blip_samples.size()-1, 0)
	blip_sample = _blip_samples[_generator.randi_range(0, _limit)] as AudioStream
	return blip_sample


func get_space_blip_sample() -> AudioStream:
	var blip_sample:AudioStream
	
	if _blip_space_samples.empty():
		return null
	
	var _limit = max(_blip_samples.size()-1, 0)
	blip_sample = _blip_space_samples[_generator.randi_range(0, _limit)] as AudioStream
	
	return blip_sample

##########
# Private things
##########

const _DEFATULT_STRING = """This is a sample text.
[center] This'll not be displayed in game.
(At least, if you set an script to DialogBaseNode).[/center]
"""
const _PREVIEW_COLOR = Color("#6d0046ff")

var _line_count := -1
var _last_wordwrap_size := Vector2()
var _last_line_count := 0

var _original_size := Vector2()

# Audio
var _blip_generator:AudioStreamPlayer
var _blip_samples:Array = [] setget set_blip_samples
var _blip_space_samples:Array = [] setget set_blip_space_samples
var _blip_strategy:int = BlipStrategy.NO_BLIP setget set_blip_strategy
var _blip_rate:int = 1 setget set_blip_rate
var _blip_force:bool = true setget force_blip
var _blip_map:bool = false setget map_blip_to_letter
var _blip_bus:String = "Master" setget set_audio_bus

var _blip_counter:int = 0
var _already_played:bool = false

var _generator = RandomNumberGenerator.new()

var _char_position = 0
var _scrolling = false

func _update_displayed_text() -> void:
	if _scrolling:
		return
	
	var _character = _get_current_character()
	_on_character_displayed(_character)
	
	if text_autoscroll:
		_scroll_to_new_line()
	
	emit_signal("character_displayed", _character)
	_char_position += 1
	
	if _character in "\t\n\r":
		_update_displayed_text()
		return
	
	text_node.set_deferred("visible_characters", text_node.visible_characters+1)
	
	if text_node.visible_characters >= text_node.get_total_character_count()-1:
		_text_timer.stop()
		_blip_counter = 0
		_char_position = text_node.get_total_character_count()
		_already_played = false
		emit_signal("text_displayed")
		
		if text_show_scroll_at_end:
			_show_scroll()
	else:
		_text_timer.start(text_speed)


func _update_original_size() -> void:
	_original_size = rect_size


func _enable_fit_content_height():
	if !text_autoscroll:
		text_node.fit_content_height = true


func _disable_fit_content_height():
	text_node.fit_content_height = false


func _show_scroll() -> void:
	text_node.scroll_active = true


func _hide_scroll() -> void:
	text_node.scroll_active = false


# This doesn't works too well with text_speed < 0.1 and q_max_lines <= 3
func _scroll_to_new_line() -> void:
	var height := text_node.get_content_height()
	var font := text_node.get_font("normal_font")
	var font_height := font.get_height()+get_constant("line_separation", "RichTextLabel")
	var scroll := text_node.get_v_scroll()

	var current_text = text_node.text.left(_char_position)
	var wordwrap_size:Vector2= font.get_wordwrap_string_size(current_text, text_node.rect_size.x)
	var text_container_height = text_node.rect_size.y
	
	var q_max_lines = int(text_container_height/font_height)
	var visible_line_count = text_node.get_visible_line_count()
	
	var _need_to_scroll = false
	
	if wordwrap_size.y > _last_wordwrap_size.y:
		_line_count += 1
		var space_left = text_container_height-wordwrap_size.y
		
		# Negative value? That means we've reached the end of the container
		# Scroll that thing!
		if space_left < 0:
			_need_to_scroll = true
	
	if _need_to_scroll:
		var tween = Tween.new()
		tween.connect("tween_all_completed", tween, "queue_free")
		tween.connect("tween_all_completed", self, "set", ["_scrolling", false])
		tween.connect("tween_all_completed", _text_timer, "start", [text_speed])
		get_tree().root.add_child(tween)
		tween.interpolate_property(scroll, "value", null, scroll.value+font_height, 0.8)
		_scrolling = true
		tween.start()
		
#		scroll.set_deferred("value", scroll.value+font_height)
		
	_last_wordwrap_size = wordwrap_size
	_last_line_count = _line_count


func _set_bubble_anchor(value:int) -> void:
	bubble_anchor = value
	update()
	property_list_changed_notify()


func _set_bubble_offset(value:Vector2) -> void:
	bubble_offset = value
	update()
	property_list_changed_notify()


func _get_current_character() -> String:
	var _text:String = text_node.text
	
	if _text == "":
		_text = " "
	
	var _text_length = _text.length()-1
	var _text_visible_characters = clamp(_char_position, 0, _text_length)
	var _current_character = _text[min(_text_length, _text_visible_characters)]
	return _current_character


func _get_minimum_size() -> Vector2:
	var style:StyleBox = _get_text_style()
	var ms:Vector2 = Vector2()
	var font:Font = get_font("normal_font")
	
	for child in get_children():
		child = child as Control
		
		if !child or not child.is_visible_in_tree():
			continue
		
		if child.is_set_as_toplevel():
			continue
		
		var minsize:Vector2 = child.get_combined_minimum_size()
		ms.x = max(ms.x, minsize.x)
		ms.y = max(ms.y, minsize.y)
	
	if style:
		ms += style.get_minimum_size()
	
	if font:
		ms.y += font.get_height()*1.2
		
	return ms


func _get_text_style() -> StyleBox:
	if has_stylebox("text") or has_stylebox_override("text"):
		return get_stylebox("text")
	if has_stylebox("text", "DialogNode"):
		return get_stylebox("text", "DialogNode")
	return null


func _get_bubble_style() -> StyleBox:
	return null


func _draw_text_style() -> void:
	var style:StyleBox = _get_text_style()
	var ci = get_canvas_item()
	style = get_stylebox("text", "DialogNode")
	style.draw(ci, Rect2(Vector2(), rect_size))
	
	
func _draw_bubble_style():
	var bubble_style := get_stylebox("bubble", "DialogNode") as StyleBoxTexture
	if not bubble_style:
		return
	
	var bubble_icon:Texture = bubble_style.texture
	if not bubble_icon:
		return
	
	var size := Vector2()
	var offset := Vector2()
	
	match bubble_anchor:
		BubblePosition.CENTER_TOP:
			offset = Vector2(0, bubble_style.margin_bottom)
			offset.y += -bubble_icon.get_size().y
			continue
		BubblePosition.CENTER_DOWN:
			offset = Vector2(0, -bubble_style.margin_top)
			offset.y += rect_size.y
			continue
		BubblePosition.CENTER_TOP, BubblePosition.CENTER_DOWN:
			offset.x += rect_size.x/2
		BubblePosition.CENTER_LEFT:
			offset = Vector2(-bubble_style.margin_left, 0)
			offset.x += -bubble_icon.get_size().x
			continue
		BubblePosition.CENTER_RIGHT:
			offset = Vector2(bubble_style.margin_right, 0)
			offset.x += rect_size.x
			continue
		BubblePosition.CENTER_LEFT, BubblePosition.CENTER_RIGHT:
			offset.y += rect_size.y/2
	
	offset += bubble_offset
	size = bubble_icon.get_size()
	
	draw_texture_rect(bubble_icon, Rect2(offset, size), false, bubble_style.modulate_color)


func _blip(with_sound:AudioStream) -> void:
	if not is_instance_valid(_blip_generator):
		_blip_generator = AudioStreamPlayer.new()
		add_child(_blip_generator)
	
	var _stream:AudioStream = with_sound
	
	if _stream == null:
		return
	
	_blip_generator.bus = _blip_bus
	_blip_generator.stream = _stream
	_blip_generator.play()


func _on_character_displayed(character:String) -> void:
	var _blip_sample:AudioStream
	var current_text = text_node.text.left(text_node.visible_characters)

	match _blip_strategy:
		BlipStrategy.BLIP_LOOP:
			
			if _blip_counter % _blip_rate == 0:
				if character in " " or character.strip_escapes().empty():
					_blip_sample = get_space_blip_sample()
					_blip(_blip_sample)
					_blip_counter = 0
					return
				
				_blip_sample = get_blip_sample(character)
				
				# First, verify if the node exists
				if is_instance_valid(_blip_generator):
					if not _blip_generator.is_playing() or _blip_force:
						_blip(_blip_sample)
				else:
					# If it doesn't, blip inmediatly
					_blip(_blip_sample)
			
			_blip_counter += 1
				
			
		BlipStrategy.BLIP_ONCE:
			if _already_played:
				return
			_blip_sample = get_blip_sample()
			_blip(_blip_sample)
			_already_played = true


func _notification(what:int) -> void:
	match what:
		NOTIFICATION_READY:
			if Engine.editor_hint:
				return
			if is_instance_valid(get_parent()):
				get_parent().connect("ready", self, "_update_original_size")
			
		NOTIFICATION_DRAW:
			_draw_text_style()
			_draw_bubble_style()
			

		NOTIFICATION_SORT_CHILDREN:
			# Literally replicate panel behaviour
			var style:StyleBox = _get_text_style()
			var size:Vector2 = rect_size
			var offset:Vector2 = Vector2()
			
			if style:
				size -= style.get_minimum_size()
				offset += style.get_offset()
			
			for child_idx in get_child_count():
				var child = get_child(child_idx) as Control
				
				if not child or not child.is_visible_in_tree():
					continue
				if child.is_set_as_toplevel():
					continue
				
				fit_child_in_rect(child, Rect2(offset, size))


func _init() -> void:
	_text_timer = Timer.new()
	_text_timer.connect("timeout", self, "_update_displayed_text")
	add_child(_text_timer)
	
	text_node = RichTextLabel.new()
	text_node.bbcode_enabled = true
	text_node.scroll_active = false
	text_node.mouse_filter = Control.MOUSE_FILTER_PASS
	text_node.name = "TextNode"
	text_node.size_flags_horizontal = SIZE_EXPAND_FILL
	text_node.size_flags_vertical = SIZE_EXPAND_FILL
	var scroll := text_node.get_v_scroll()
	if Engine.editor_hint:
		connect("draw", text_node, "set", ["bbcode_text", _DEFATULT_STRING])
	add_child(text_node)
	
	_blip_samples = []
	_blip_space_samples = []
