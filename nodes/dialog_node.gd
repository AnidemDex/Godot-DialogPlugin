tool
extends Control
class_name DialogNode

## Emmited when a portrait was added
signal character_joined(character)
## Emmited when a portrait that is already in the scene, changes
signal character_portrait_changed(character, portrait)
## Emmited when a portrait is removed from scene
signal character_leaved(character)

## Emmited when an option is added
signal option_added(option_button)
## Emmited when an option is selected
signal option_selected(option_string)

## Emmited eveytime that a character is displayed
signal text_character_displayed(character)
## Emmited eveytime that a word is displayed
signal text_word_displayed(word)
## Emmited when the text was fully displayed
signal text_all_displayed(text)

const _DEFATULT_STRING = """This is a sample text.
This'll not be displayed in game"""
const _BlipData = preload("res://addons/textalog/resources/blip_data.gd")
const _Character = preload("res://addons/textalog/resources/character_class/character_class.gd")
const _CharacterRect = preload("res://addons/textalog/nodes/character_rect.gd")

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
var uses_bubble:bool = false

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
var blip_data:_BlipData = null
var blip_strategy:int = BlipStrategy.NO_BLIP setget set_blip_strategy
var blip_rate:int = 1 setget set_blip_rate
var blip_force:bool = true setget force_blip
var blip_map:bool = false setget map_blip_to_letter
var blip_bus:String = "Master" setget set_audio_bus

var _blip_generator:AudioStreamPlayer
var _blip_counter:int = 0
var _already_played:bool = false

# Options
var option_button_scene:PackedScene
var _option_data := {}
var _default_option_container:Container

# Characters
var current_speaker
# {character: CharacterData}
var _know_characters := {}

class CharacterData:
	var node:Node = null
	var joined:bool = false
	var portrait:String = ""

## Shows a text inmediatly in screen
func show_text(text:String, with_text_speed:float=0):
	show()
	set_text(text)
	display_text()


## Adds a selectable option on screen
func add_option(option:String) -> void:
	var button:BaseButton
	if option_button_scene:
		button = option_button_scene.instance() as BaseButton
	
	if not is_instance_valid(button):
		button = _get_default_option_button()
	
	button.connect("ready", self, "emit_signal", ["option_added", button])
	button.connect("pressed", self, "_option_button_pressed", [option])
	_option_data[option] = button
	
	button.set("name", option)
	button.set("text", option)
	
	_get_option_container().add_child(button)

func remove_option(option:String) -> void:
	if option in _option_data and is_instance_valid(_option_data[option]):
		_option_data[option].queue_free()
		_option_data.erase(option)


func remove_all_options() -> void:
	for child in _get_option_container().get_children():
		child.queue_free()
	_option_data.clear()


func set_dialog_name(string:String) -> void:
	if is_instance_valid(_get_name_label()):
		if string == "":
			_get_name_label().hide()
			return
		
		_get_name_label().show()
		_get_name_label().set("text", string)


func set_current_speaker(node:Node) -> void:
	if not is_instance_valid(node):
		set_dialog_name("")
		return
	
	var _char:_Character = node.get("character") as _Character
	if not _char:
		set_dialog_name("")
		return
	
	if not _char in _know_characters:
		register_node_for_character(node)
		character_join(_char)
	
	var _name:String = str(_char.get("name"))
	
	set_dialog_name(_name)

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
	
	_scroll_to_new_line()
	emit_signal("text_all_displayed", text_node.text)


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
	_last_max = 0
	_scrolling = false
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


func set_audio_bus(bus:String) -> void:
	blip_bus = bus


func set_blip_rate(value:int) -> void:
	blip_rate = max(1, value)


func force_blip(value:bool) -> void:
	blip_force = value


func map_blip_to_letter(value:bool) -> void:
	blip_map = value


func get_blip_sample(for_char:String="") -> AudioStream:
	if blip_data:
		return blip_data.get_sample(for_char)
	return null

func add_character(character:_Character) -> void:
	if character in _know_characters:
		return
	
	_know_characters[character] = CharacterData.new()

func get_character_node(character:_Character) -> Node:
	if character in _know_characters:
		return _know_characters[character]["node"]
	return null


func character_join(character:_Character) -> void:
	if not character in _know_characters:
		add_character(character)
	
	var node = get_character_node(character)
	var joined:bool = _know_characters[character].joined
	
	if joined:
		return
	
	if not is_instance_valid(node):
		if is_instance_valid(_get_portrait_reference()):
			node = _CharacterRect.new()
			node.character = character
			_know_characters[character].node = node
			_get_portrait_reference().add_child(node)
			node.set_anchors_and_margins_preset(Control.PRESET_WIDE)

	
	if is_instance_valid(node):
		if node.has_method("join"):
			node.call("join")
		if node.has_method("set_portrait"):
			node.call("set_portrait", "default")
	
	_know_characters[character].joined = true
	emit_signal("character_joined")


func character_leave(character:_Character) -> void:
	pass

func character_change_portrait(character:_Character, portrait:String) -> void:
	pass


func register_node_for_character(node:Node) -> void:
	var character:_Character = node.get("character") as _Character
	if not character:
		return
	
	var data = CharacterData.new()
	
	if character in _know_characters:
		data = _know_characters[character]
	
	data["node"] = node
	_know_characters[character] = data
	update()


func _update_displayed_text() -> void:
	if _current_line_left.empty():
		if _text_left.empty():
			# No more lines? Job done
			_text_timer.stop()
			_blip_counter = 0
			_already_played = false
			_cursor_position = -1
			_current_line = -1
			if show_scrollbar == TextScroll.AT_END:
				_show_scrollbar()
			
			emit_signal("text_all_displayed", text_node.text)
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
		
		_text_timer.start(text_speed)
		return
	
	match text_update:
		TextUpdate.EVERY_CHARACTER:
			var _character = _current_line_left.pop_back()
			if _character in "\t\n\r":
				return
			
			_blip_for(_character)
			text_node.add_text(_character)
			emit_signal("text_character_displayed", _character)
		
		TextUpdate.EVERY_WORD:
			if _cursor_position > 0:
				_blip_for(" ")
				text_node.add_text(" ")
			
			var word = _current_line_left.pop_back()
			_blip_for(word)
			text_node.add_text(word)
			emit_signal("text_word_displayed", word)
	
	_cursor_position += 1


func _show_scrollbar() -> void:
	text_node.scroll_active = true


func _hide_scrollbar() -> void:
	text_node.scroll_active = false

var _last_max:float = 0.0

func _scroll_to_new_line() -> void:
	if _scrolling:
		return
	
	var font := text_node.get_font("normal_font")
	var scroll := text_node.get_v_scroll()
	var text_container_height = text_node.rect_size.y
	var q_max_lines = floor(text_container_height/(font.get_height()))
	var can_scroll = false
	
	if (
		scroll.max_value > (font.get_height() * q_max_lines) and
		scroll.max_value > _last_max and
		_current_line >= q_max_lines
		):
		can_scroll = true
		_last_max = scroll.max_value
	else:
		_scrolling = false
		can_scroll = false
	
	match scroll_method:
		ScrollMethod.PAUSE_AND_THEN_SCROLL:
			if can_scroll:
				_text_timer.stop()
		
		ScrollMethod.SCROLL_WHILE_SHOW_TEXT:
			can_scroll = true
		
		ScrollMethod.INMEDIATE:
			if not text_node.scroll_following:
				text_node.scroll_following = true
			return
	
	if can_scroll:
		var tween = Tween.new()
		_scrolling = true
		tween.connect("tween_all_completed", tween, "queue_free")
		tween.connect("tween_all_completed", self, "set", ["_scrolling", false])
		tween.connect("tween_all_completed", _text_timer, "start", [text_speed], CONNECT_DEFERRED)
		add_child(tween)
		tween.interpolate_property(scroll, "value", null, scroll.max_value, scroll_speed)
		tween.start()


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
					_blip_sample = get_blip_sample(" ")
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

func _option_button_pressed(option_string:String) -> void:
	remove_all_options()
	emit_signal("option_selected", option_string)


func _global_tree_changed() -> void:
	if Engine.editor_hint:
		update()


func _get_option_container() -> Container:
	if is_instance_valid(get_node_or_null("Options")):
		return get_node("Options")as Container
	return _default_option_container


func _get_default_option_button() -> Button:
	var button = Button.new()
	var _n = ["hover", "pressed", "focus", "disabled", "normal"]
	for theme_name in _n:
		button.add_stylebox_override(theme_name, get_stylebox(theme_name, "DialogButton"))
	
	return button


func _get_name_label() -> Control:
	return get_node_or_null("Name") as Control


func _get_portrait_reference() -> Control:
	return get_node_or_null("Reference") as Control


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
	p.append({"name":"scroll_speed", "type":TYPE_REAL, "hint":PROPERTY_HINT_RANGE, "hint_string":"0,1,0.01,or_greater", "usage":PROPERTY_USAGE_DEFAULT})
	
	p.append({"name":"uses_bubble", "type":TYPE_BOOL, "usage":PROPERTY_USAGE_DEFAULT})
	
	# Audio
	p.append({"name":"Audio", "type":TYPE_NIL, "usage":PROPERTY_USAGE_CATEGORY})
	p.append({"name":"blip_data", "type":TYPE_OBJECT, "usage":PROPERTY_USAGE_DEFAULT})
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
		
	p.append({"name":"Characters", "type":TYPE_NIL, "usage":PROPERTY_USAGE_CATEGORY})
	for character in _know_characters:
		p.append({"name":"characters/"+character.name, "type":TYPE_NIL, "usage":PROPERTY_USAGE_EDITOR})

	return p


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if not _text_timer.is_connected("timeout", self, "_update_displayed_text"):
				_text_timer.connect("timeout", self, "_update_displayed_text")
			
			var scroll = text_node.get_v_scroll()
			if not scroll.is_connected("changed", self, "_scroll_to_new_line"):
				scroll.connect("changed", self, "_scroll_to_new_line")
			
			_text_container.set_anchors_and_margins_preset(Control.PRESET_WIDE)
			
			if Engine.editor_hint:
				get_tree().connect("tree_changed", self, "_global_tree_changed")
			continue
		
		NOTIFICATION_READY:
			if Engine.editor_hint:
				update()
		
		NOTIFICATION_RESIZED:
			if Engine.editor_hint:
				update()
			
		NOTIFICATION_DRAW:
			if Engine.editor_hint:
				if _get_portrait_reference():
					draw_rect(_get_portrait_reference().get_rect(), Color.red, false)
					draw_string(get_font("source","EditorFonts"), _get_portrait_reference().rect_position, "Characters will use this rect as reference for their portraits by default")
				
				draw_rect(text_node.get_rect(), Color.red, false)
				draw_rect(_get_option_container().get_rect(), Color.red, false)
				draw_string(get_font("source","EditorFonts"), _get_option_container().rect_position, "Options will be added here")
				
				if _get_name_label():
					draw_rect(_get_name_label().get_rect(), Color.red, false)
					draw_string(get_font("source","EditorFonts"), _get_name_label().rect_position, "Speaker's name will appear here")
				
				for data in _know_characters.values():
					var node = data.get("node")
					if node:
						draw_string(get_font("source","EditorFonts"), node.get_position()-rect_position, "Recognized")
		
		NOTIFICATION_ENTER_TREE, NOTIFICATION_THEME_CHANGED:
			
			if is_instance_valid(_text_container):
				_text_container.add_stylebox_override("panel", get_stylebox("background", "DialogNode"))
			
			if is_instance_valid(_get_name_label()):
				_get_name_label().add_stylebox_override("normal", get_stylebox("name", "DialogNode"))
			
			minimum_size_changed()
		
		NOTIFICATION_EXIT_TREE:
			_text_timer.stop()
			
			if get_tree().is_connected("tree_changed", self, "_global_tree_changed"):
				get_tree().disconnect("tree_changed", self, "_global_tree_changed")


func _init() -> void:
	theme = load("res://addons/textalog/assets/themes/default_theme/default.tres")
	name = "DialogNode"
	
	_text_timer = Timer.new()
	add_child(_text_timer)
	
	_text_container = PanelContainer.new()
	_text_container.show_behind_parent = true
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
	
	_default_option_container = HBoxContainer.new()
	_default_option_container.alignment = BoxContainer.ALIGN_CENTER
	_default_option_container.grow_vertical = Control.GROW_DIRECTION_BEGIN
	_default_option_container.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_default_option_container.rect_min_size = Vector2(0, 24)
	_default_option_container.set_anchors_and_margins_preset(Control.PRESET_TOP_WIDE)
	add_child(_default_option_container)
