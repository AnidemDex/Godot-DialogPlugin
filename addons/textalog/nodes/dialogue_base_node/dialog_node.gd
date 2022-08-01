tool
extends Control

## Emmited when a portrait was added
signal portrait_added(character, portrait)
## Emmited when a portrait that is already in the scene, changes
signal portrait_changed(character, portrait)
## Emmited when a portrait is removed from scene
signal portrait_removed(character)

## Emmited when an option is added
signal option_added(option_button)
## Emmited when an option is selected
signal option_selected(option_string)

## Emmited eveytime that a character is displayed
signal character_displayed(character)
## Emmited eveytime that a word is displayed
signal word_displayed(word)
## Emmited when the text was fully displayed
signal text_displayed(text)

const _DEFATULT_STRING = """This is a sample text.
[center] This'll not be displayed in game.[/center]
"""
## Anchor points that the bubble can take as reference

enum BlipStrategy {NO_BLIP, BLIP_ONCE, BLIP_LOOP}
enum TextUpdate {EVERY_CHARACTER, EVERY_WORD, ALL_AT_ONCE, MANUALLY}
enum TextScroll {NEVER, WHEN_POSSIBLE, AT_END}
enum ScrollMethod {INMEDIATE, PAUSE_AND_THEN_SCROLL, SCROLL_WHILE_SHOW_TEXT}

var text_update:int = TextUpdate.EVERY_CHARACTER setget set_text_update
## The speed that the node uses to wait before adding another character.
## Values between 0.02 and 0.08 are good ones to use.
var text_speed:float = 0.02
## If true, DialogManager will try to scroll the text to fit new content
var text_autoscroll:bool = false setget set_text_autoscroll
var show_scrollbar:int = TextScroll.WHEN_POSSIBLE setget set_show_scrollbar
var scroll_method:int = ScrollMethod.INMEDIATE setget set_scroll_method
var scroll_speed:float = 0.8

## The node that actually displays the text
var text_node:RichTextLabel setget ,get_text_node

var _text_timer:Timer
var _text_container:PanelContainer
var _text_left := []
var _current_line_left := []
var _current_line := -1
var _cursor_position := -1
var _scrolling := false

var _line_count := -1
var _last_wordwrap_size := Vector2()
var _last_line_count := 0

# Audio
var blip_samples:Array = [] setget set_blip_samples
var blip_space_samples:Array = [] setget set_blip_space_samples
var blip_strategy:int = BlipStrategy.NO_BLIP setget set_blip_strategy
var blip_rate:int = 1 setget set_blip_rate
var blip_force:bool = true setget force_blip
var blip_map:bool = false setget map_blip_to_letter
var blip_bus:String = "Master" setget set_audio_bus

var _blip_generator:AudioStreamPlayer
var _blip_counter:int = 0
var _already_played:bool = false

var _generator = RandomNumberGenerator.new()

## Shows a text inmediatly in screen
func show_text(text:String, with_text_speed:float=0):
	show()
	set_text(text)
	display_text()


## Adds a selectable option on screen
func add_option(option:String) -> void:
	## TODO
	#options_manager.add_option(option)
	pass



##########
## DialogFunctions
##########

## Calling this method will make to all text to be visible inmediatly
func display_all_text() -> void:
	_text_left.invert()
	var i := 0
	for _text in _text_left:
		text_node.add_text(_text)
		if i >= 0 and i < _text_left.size() - 1:
			text_node.newline()
		i += 1
	_text_left = []
	
	if show_scrollbar:
		text_node.scroll_active = true
	emit_signal("text_displayed", text_node.text)


## Starts displaying the text setted by [method set_text]
func display_text() -> void:
	match text_update:
		TextUpdate.ALL_AT_ONCE:
			call_deferred("display_all_text")
		
		TextUpdate.EVERY_WORD, TextUpdate.EVERY_CHARACTER:
			_text_timer.start(text_speed)
		
		TextUpdate.MANUALLY:
			pass


## Set the text that this node will display. Call [method display_text]
## after using this method to display the text.
func set_text(text:String) -> void:
	_text_timer.stop()
	_text_left = text.split("\n")
	_text_left.invert()
	_cursor_position = 0
	text_node.bbcode_text = ""
	
	_line_count = 0
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


func set_text_update(value:int) -> void:
	text_update = clamp(value, 0, TextUpdate.size()-1)
	property_list_changed_notify()


func set_text_autoscroll(value:bool) -> void:
	text_autoscroll = value
	property_list_changed_notify()


func set_show_scrollbar(value:int) -> void:
	show_scrollbar = clamp(value, 0, TextScroll.size()-1)
	property_list_changed_notify()
	
	match show_scrollbar:
		TextScroll.AT_END, TextScroll.NEVER:
			_hide_scrollbar()
		TextScroll.WHEN_POSSIBLE:
			_show_scrollbar()


func set_scroll_method(value:int) -> void:
	scroll_method = clamp(value, 0, ScrollMethod.size()-1)
	
	match scroll_method:
		ScrollMethod.INMEDIATE:
			text_node.scroll_following = true
		
		_:
			text_node.scroll_following = false

func set_blip_strategy(strategy:int) -> void:
	blip_strategy = clamp(strategy, 0, BlipStrategy.size()-1)
	property_list_changed_notify()


## Set the blip samples that'll be used on blip
func set_blip_samples(samples:Array) -> void:
	blip_samples = samples.duplicate()


func set_blip_space_samples(samples:Array) -> void:
	blip_space_samples = samples.duplicate()


func set_audio_bus(bus:String) -> void:
	blip_bus = bus


func set_blip_rate(value:int) -> void:
	blip_rate = max(1, value)


func force_blip(value:bool) -> void:
	blip_force = value


func map_blip_to_letter(value:bool) -> void:
	blip_map = value


func get_blip_sample(for_char:String="") -> AudioStream:
	var blip_sample:AudioStream
	if blip_samples.empty():
		return null
	
	if blip_map:
		
		pass
	var _limit = max(blip_samples.size()-1, 0)
	blip_sample = blip_samples[_generator.randi_range(0, _limit)] as AudioStream
	return blip_sample


func get_space_blip_sample() -> AudioStream:
	var blip_sample:AudioStream
	
	if blip_space_samples.empty():
		return null
	
	var _limit = max(blip_space_samples.size()-1, 0)
	blip_sample = blip_space_samples[_generator.randi_range(0, _limit)] as AudioStream
	
	return blip_sample


func _update_displayed_text() -> void:
	if _scrolling and scroll_method == ScrollMethod.PAUSE_AND_THEN_SCROLL:
		_text_timer.start(text_speed)
		return
	
	if _current_line_left.empty():
		if _text_left.empty():
			## TODO
			# No more lines? Job done
			_text_timer.stop()
			_blip_counter = 0
			_already_played = false
			_cursor_position = -1
			_current_line = -1
			if show_scrollbar == TextScroll.AT_END:
				_show_scrollbar()
			
			emit_signal("text_displayed", text_node.text)
			return
		
		var current_text:String = _text_left.pop_back()
		_cursor_position = 0
		_current_line += 1
		
		match text_update:
			TextUpdate.EVERY_CHARACTER:
				for _char in current_text:
					_current_line_left.append(_char)
				_current_line_left.invert()
				
			TextUpdate.EVERY_WORD:
				_current_line_left = current_text.split(" ", false)
				_current_line_left.invert()
		
		if show_scrollbar in [TextScroll.AT_END, TextScroll.NEVER]:
			_hide_scrollbar()
		
		if _current_line > 0:
			text_node.newline()
			_scroll_to_new_line()
		
		_text_timer.start(text_speed)
		return
	
	match text_update:
		TextUpdate.EVERY_CHARACTER:
			var _character = _current_line_left.pop_back()
			if _character in "\t\n\r":
#				_update_displayed_text()
				return
			
			_blip_for(_character)
			text_node.add_text(_character)
			emit_signal("character_displayed", _character)
		
		TextUpdate.EVERY_WORD:
			if _cursor_position > 0:
				_blip_for(" ")
				text_node.add_text(" ")
			
			var word = _current_line_left.pop_back()
			_blip_for(word)
			text_node.add_text(word)
			emit_signal("word_displayed", word)
	
	_cursor_position += 1
#	_text_timer.start(text_speed)
	if text_autoscroll and scroll_method != ScrollMethod.INMEDIATE:
		_scroll_to_new_line()
	else:
		_text_timer.start(text_speed)


func _enable_fit_content_height():
	if !text_autoscroll:
		text_node.fit_content_height = true


func _disable_fit_content_height():
	text_node.fit_content_height = false


func _show_scrollbar() -> void:
	text_node.scroll_active = true


func _hide_scrollbar() -> void:
	text_node.scroll_active = false


# This doesn't works too well with text_speed < 0.1 and q_max_lines <= 3
func _scroll_to_new_line() -> void:
	# No need since is height of the current line
#	var height := text_node.get_content_height()
	
	var font := text_node.get_font("normal_font")
	var font_height := font.get_height()+get_constant("line_separation", "RichTextLabel")
	var scroll := text_node.get_v_scroll()

	var current_text = text_node.text
	var wordwrap_size:Vector2 = font.get_wordwrap_string_size(current_text, text_node.rect_size.x)
	var text_container_height = text_node.rect_size.y
	
	var q_max_lines = ceil(text_container_height/font_height)
	var visible_line_count = text_node.get_visible_line_count()
	
	var _need_to_scroll = false
	
	if wordwrap_size.y > _last_wordwrap_size.y:
		var space_left = text_container_height-wordwrap_size.y
		
		# Negative value? That means we've reached the end of the container
		# Scroll that thing!
		if space_left < 0:
			_need_to_scroll = true
#	prints(current_text, wordwrap_size, text_node.rect_size, visible_line_count, q_max_lines, text_node.get_line_count())
	if _need_to_scroll:
		_scrolling = true
		var tween = Tween.new()
		tween.connect("tween_all_completed", tween, "queue_free")
		tween.connect("tween_all_completed", self, "set", ["_scrolling", false])
		tween.connect("tween_all_completed", _text_timer, "start", [text_speed])
		add_child(tween)
		tween.interpolate_property(scroll, "value", null, scroll.value+font_height, 0.8)
		tween.start()
	else:
		_scrolling = false
		_text_timer.start(text_speed)

	_last_wordwrap_size = wordwrap_size
	_last_line_count = _line_count


func _get_minimum_size() -> Vector2:
	var style:StyleBox = get_stylebox("background", "DialogNode")
	var ms:Vector2 = Vector2()
	var font:Font = get_font("normal_font")
	
	ms.x = 128
	
	if style:
		ms += style.get_minimum_size()
	
	if font:
		ms.y += font.get_height()
		
	return ms


func _blip(with_sound:AudioStream) -> void:
	if not is_instance_valid(_blip_generator):
		_blip_generator = AudioStreamPlayer.new()
		add_child(_blip_generator)
	
	var _stream:AudioStream = with_sound
	
	if _stream == null:
		return
	
	_blip_generator.bus = blip_bus
	_blip_generator.stream = _stream
	_blip_generator.play()


func _blip_for(string:String) -> void:
	var _blip_sample:AudioStream

	match blip_strategy:
		BlipStrategy.BLIP_LOOP:
			
			if _blip_counter % blip_rate == 0:
				if string in " " or string.strip_escapes().empty():
					_blip_sample = get_space_blip_sample()
					_blip(_blip_sample)
					_blip_counter = 0
					return
				
				_blip_sample = get_blip_sample(string)
				
				# First, verify if the node exists
				if is_instance_valid(_blip_generator):
					if not _blip_generator.is_playing() or blip_force:
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


func _hide_script_from_inspector():
	return true


func _set(property: String, value) -> bool:
	return false


func _get(property: String):
	return

func property_can_revert(property:String):
	var p = PoolStringArray(["text_update", "text_speed", "text_autoscroll", "scroll_method", "show_scrollbar", "scroll_speed", "uses_bubble"])
	return property in p or property.begins_with("blip")

func property_get_revert(property:String):
	match property:
		"text_update":
			return 0
		"text_speed":
			return 0.02
		"text_autoscroll":
			return false
		"scroll_method":
			return 0
		"show_scrollbar":
			return 0
		"scroll_speed":
			return 0.8
		"uses_bubble":
			return false
		
		"blip_strategy":
			return 0
		"blip_bus":
			return "Master"
		"blip_rate":
			return 1
		"blip_force":
			return true
		"blip_map":
			return false
		"blip_samples":
			return []
		"blip_space_samples":
			return []

func _get_property_list() -> Array:
	var p := []
	var hint_string:String = ""
	# DialogNode
	p.append({"name":"Dialog Node", "type":TYPE_NIL, "usage":PROPERTY_USAGE_CATEGORY})
	p.append({"name":"text", "type":TYPE_STRING, "usage":PROPERTY_USAGE_DEFAULT_INTL})
	
	hint_string = str(TextUpdate.keys()).trim_prefix("[").trim_suffix("]").capitalize()
	p.append({"name":"text_update", "type":TYPE_INT, "hint":PROPERTY_HINT_ENUM, "hint_string":hint_string, "usage":PROPERTY_USAGE_DEFAULT})
	match text_update:
		TextUpdate.MANUALLY, TextUpdate.ALL_AT_ONCE:
			pass
		TextUpdate.EVERY_CHARACTER, TextUpdate.EVERY_WORD:
			p.append({"name":"text_speed", "type":TYPE_REAL, "usage":PROPERTY_USAGE_DEFAULT})
	
	p.append({"name":"text_autoscroll", "type":TYPE_BOOL, "usage":PROPERTY_USAGE_DEFAULT})
	if text_autoscroll:
		hint_string = str(ScrollMethod.keys()).trim_prefix("[").trim_suffix("]").capitalize()
		p.append({"name":"scroll_method", "type":TYPE_INT, "hint":PROPERTY_HINT_ENUM, "hint_string":hint_string, "usage":PROPERTY_USAGE_DEFAULT})
	hint_string = str(TextScroll.keys()).trim_prefix("[").trim_suffix("]").capitalize()
	p.append({"name":"show_scrollbar", "type":TYPE_INT, "hint":PROPERTY_HINT_ENUM, "hint_string":hint_string, "usage":PROPERTY_USAGE_DEFAULT})
	p.append({"name":"scroll_speed", "type":TYPE_REAL, "usage":PROPERTY_USAGE_DEFAULT})
	
	p.append({"name":"uses_bubble", "type":TYPE_BOOL, "usage":PROPERTY_USAGE_DEFAULT})
	
	# Audio
	p.append({"name":"Audio", "type":TYPE_NIL, "usage":PROPERTY_USAGE_CATEGORY})
	hint_string = str(BlipStrategy.keys()).trim_prefix("[").trim_suffix("]").capitalize()
	p.append({"name":"blip_strategy", "type":TYPE_INT, "hint":PROPERTY_HINT_ENUM, "hint_string":hint_string, "usage":PROPERTY_USAGE_DEFAULT})
	match blip_strategy:
		BlipStrategy.NO_BLIP:
			pass
		
		BlipStrategy.BLIP_ONCE, BlipStrategy.BLIP_LOOP:
			hint_string = ""
			for bus_idx in AudioServer.bus_count:
				hint_string += "%s,"%AudioServer.get_bus_name(bus_idx)
				hint_string = hint_string.trim_suffix(",")
			p.append({"name":"blip_bus", "type":TYPE_STRING, "hint":PROPERTY_HINT_ENUM, "hint_string":hint_string, "usage":PROPERTY_USAGE_DEFAULT})
			continue
		
		BlipStrategy.BLIP_LOOP:
			p.append({"name":"blip_rate", "type":TYPE_INT, "hint":PROPERTY_HINT_RANGE, "hint_string":"1,10,1,or_greater", "usage":PROPERTY_USAGE_DEFAULT})
			p.append({"name":"blip_force", "type":TYPE_BOOL, "usage":PROPERTY_USAGE_DEFAULT})
			p.append({"name":"blip_map", "type":TYPE_BOOL, "usage":PROPERTY_USAGE_DEFAULT})
	
	p.append({"name":"Blip", "type":TYPE_NIL, "usage":PROPERTY_USAGE_GROUP})
	p.append({"name":"blip_samples", "type":TYPE_ARRAY, "hint":24, "hint_string":"17/17:AudioStream", "usage":PROPERTY_USAGE_DEFAULT})
	p.append({"name":"blip_space_samples", "type":TYPE_ARRAY, "hint":24, "hint_string":"17/17:AudioStream", "usage":PROPERTY_USAGE_DEFAULT})
	
	# Characters
	p.append({"name":"Dialog Node", "type":TYPE_NIL, "usage":PROPERTY_USAGE_CATEGORY})
	p.append({"name":"know_characters", "type":TYPE_STRING, "usage":PROPERTY_USAGE_DEFAULT})
	return p


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			_text_timer.connect("timeout", self, "_update_displayed_text")
			
			_text_container.set_anchors_and_margins_preset(Control.PRESET_WIDE)
			continue
		
		NOTIFICATION_READY:
			if Engine.editor_hint:
				return
		
		
		NOTIFICATION_ENTER_TREE, NOTIFICATION_THEME_CHANGED:
			_text_container.add_stylebox_override("panel", get_stylebox("background", "DialogNode"))
			minimum_size_changed()
		
		NOTIFICATION_EXIT_TREE:
			_text_timer.stop()


func _init() -> void:
	theme = load("res://addons/textalog/assets/themes/default_theme/default.tres")
	name = "DialogNode"
	
	blip_samples = []
	blip_space_samples = []
	
	_text_timer = Timer.new()
	_text_timer.one_shot = true
	add_child(_text_timer)
	
	_text_container = PanelContainer.new()
	add_child(_text_container)
	
	text_node = RichTextLabel.new()
	text_node.bbcode_enabled = true
	text_node.scroll_active = false
	text_node.mouse_filter = Control.MOUSE_FILTER_PASS
	text_node.name = "TextNode"
	text_node.size_flags_horizontal = SIZE_EXPAND_FILL
	text_node.size_flags_vertical = SIZE_EXPAND_FILL
	text_node.append_bbcode(_DEFATULT_STRING)
	_text_container.add_child(text_node)
