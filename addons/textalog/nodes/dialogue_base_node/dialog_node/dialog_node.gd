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

## Emmited when the text is fully displayed
signal text_displayed
## Emmited eveytime that a character is displayed
signal character_displayed(character)

## The speed that the node uses to wait before adding another character.
## Values between 0.02 and 0.08 are good ones to use.
export(float) var text_speed:float = 0.02
## If true, DialogManager will try to scroll the text to fit new content
export(bool) var text_autoscroll:bool = true
## If true and [member text_autoscroll] is false, DialogManager will scale its size
## to fit its content.
export(bool) var text_fit_content_height:bool = true
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
	_update_displayed_text()


## Starts displaying the text setted by [method set_text]
func display_text() -> void:
	_text_timer.start(text_speed)


## Set the text that this node will display. Call [method display_text]
## after using this method to display the text.
func set_text(text:String) -> void:
	text_node.bbcode_text = text
	text_node.visible_characters = 0
	rect_min_size = _original_size
	if text_fit_content_height:
		_enable_fit_content_height()
	
	_line_count = 0
	_last_line_count = 0
	_last_wordwrap_size = Vector2()
	text_node.get_v_scroll().value = 0


## Adds text to the current one at the end. No need to call
## [method display_text] if the node is already displaying text
func add_text(text:String) -> void:
	text_node.append_bbcode(text)


## Returns the used text_node
func get_text_node() -> RichTextLabel:
	if is_instance_valid(text_node):
		return text_node
	return null

##########
# Private things
##########

const _DEFATULT_STRING = """This is a sample text.
[center] This'll not be displayed in game.
(At least, if you set an script to DialogBaseNode).[/center]
"""
const _PREVIEW_COLOR = Color("#6d0046ff")

var _line_count := 0
var _last_wordwrap_size := Vector2()
var _last_line_count := 0

var _original_size := Vector2()


func _update_displayed_text() -> void:
	var _character = _get_current_character()
	emit_signal("character_displayed", _character)
	text_node.visible_characters += 1
	
	if text_autoscroll:
		_scroll_to_new_line()
	
	if text_node.visible_characters < text_node.get_total_character_count():
		_text_timer.start(text_speed)
	else:
		_text_timer.stop()
		emit_signal("text_displayed")
		
		if text_show_scroll_at_end:
			_show_scroll()


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
	var font_height := font.get_height()
	var scroll := text_node.get_v_scroll()

	var current_text = text_node.text.left(text_node.visible_characters)
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
		if space_left < font_height:
			_need_to_scroll = true
	
	if _need_to_scroll:
		scroll.value += font_height*1.05 # Add a little bit more, just in case.
		
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
	var _text_visible_characters = clamp(text_node.visible_characters, 0, _text_length)
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
	var scroll := text_node.get_v_scroll()
	scroll.allow_greater = true
	if Engine.editor_hint:
		connect("draw", text_node, "set", ["bbcode_text", _DEFATULT_STRING])
	add_child(text_node)
