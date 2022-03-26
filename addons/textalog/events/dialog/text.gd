tool
extends Event
class_name EventDialogText

# Dialog
var display_name:String = "" setget set_display_name
var translation_key:String = "" setget set_translation_key
var text:String = "" setget set_text
export(bool) var continue_previous_text:bool = false setget enable_text_ammend
export(float, 0.01, 1.0, 0.01) var text_speed:float = 0.04 setget set_text_speed


# Audio
var audio_blip_strategy:int = DialogManager.BlipStrategy.NO_BLIP setget set_blip_strategy
var audio_same_as_character:bool = true setget use_character_sounds
var audio_blip_sounds:Array = [] setget set_audio_blip_sounds
var audio_use_space_blips:bool = false setget use_space_blips
var audio_space_blip_sounds:Array = [] setget set_space_blip_sounds
var audio_blip_rate:int = 1 setget set_audio_blip_rate
var audio_force:bool = true setget force_audio
var audio_map_blip_to_letter:bool = false setget set_map_to_letter
var audio_bus:String = "Master" setget set_audio_bus

var character:Character = null setget set_character

var sound_generator:AudioStreamPlayer = null

var _dialog_manager:DialogManager = null
var _generator := RandomNumberGenerator.new()
var _already_played:bool = false

func set_display_name(value:String) -> void:
	display_name = value
	emit_changed()
	property_list_changed_notify()


func set_text(value:String) -> void:
	text = value
	emit_changed()
	property_list_changed_notify()


func set_text_speed(value:float) -> void:
	text_speed = value
	emit_changed()


func enable_text_ammend(value:bool) -> void:
	continue_previous_text = value
	emit_changed()
	property_list_changed_notify()


func set_translation_key(value:String) -> void:
	translation_key = value
	emit_changed()
	property_list_changed_notify()


func set_character(value:Character) -> void:
	if value != character:
		character = value
		emit_changed()
	
		if character:
			set_deferred("display_name", character.display_name)
	
	property_list_changed_notify()

func use_character_sounds(value:bool) -> void:
	audio_same_as_character = value
	emit_changed()
	property_list_changed_notify()


func use_space_blips(value:bool) -> void:
	audio_use_space_blips = value
	emit_changed()
	property_list_changed_notify()


func set_blip_strategy(value:int) -> void:
	audio_blip_strategy = clamp(value, 0, DialogManager.BlipStrategy.size()-1)
	emit_changed()
	property_list_changed_notify()


func set_audio_blip_sounds(value:Array) -> void:
	audio_blip_sounds = value.duplicate()
	emit_changed()
	property_list_changed_notify()


func set_space_blip_sounds(value:Array) -> void:
	audio_space_blip_sounds = value.duplicate()
	emit_changed()
	property_list_changed_notify()


func set_audio_blip_rate(value:int) -> void:
	audio_blip_rate = max(1, value)
	emit_changed()


func set_map_to_letter(value:bool) -> void:
	audio_map_blip_to_letter = value
	emit_changed()
	property_list_changed_notify()


func force_audio(value:bool) -> void:
	audio_force = value
	emit_changed()
	property_list_changed_notify()


func set_audio_bus(value:String) -> void:
	audio_bus = value
	emit_changed()
	property_list_changed_notify()


##########
## Private
##########

func _show_text() -> void:
	get_event_node().show()
	_dialog_manager.display_text()


func _prepare_text_to_show() -> void:
	_dialog_manager.show()

	var final_text := ""

	if translation_key != "":
		final_text = tr(translation_key)
	else:
		final_text = text

	if continue_previous_text:
		_dialog_manager.add_text(final_text)
	else:
		_dialog_manager.set_text(final_text)
	
	_dialog_manager.text_speed = text_speed


func _configure_display_name() -> void:
	var name_node:Label = get_event_node().name_node
	if not is_instance_valid(name_node):
		return
	
	name_node.hide()
	if display_name != "":
		name_node.show()

	if character:
		name_node.add_color_override("font_color", character.color)
	
	name_node.text = display_name


func _configure_sound_generator() -> void:
	_dialog_manager.set_blip_strategy(audio_blip_strategy)
	if character and audio_same_as_character:
		_dialog_manager.set_blip_samples(character.blip_sounds)
	else:
		_dialog_manager.set_blip_samples(audio_blip_sounds)
	_dialog_manager.set_blip_space_samples(audio_space_blip_sounds)
	
	_dialog_manager.force_blip(audio_force)
	_dialog_manager.map_blip_to_letter(audio_map_blip_to_letter)
	
	_dialog_manager.set_blip_rate(audio_blip_rate)
	_dialog_manager.set_audio_bus(audio_bus)


func _on_text_displayed() -> void:
	finish()


func _execute() -> void:
	var node = get_event_node() as DialogNode
	if not is_instance_valid(node):
		finish()
		return
	
	_dialog_manager = node.dialog_manager as DialogManager
	if not is_instance_valid(_dialog_manager):
		finish()
		return
	
	_dialog_manager.connect("text_displayed", self, "_on_text_displayed", [], CONNECT_ONESHOT)
	
	_generator.randomize()

	_configure_display_name()
	_configure_sound_generator()
	_prepare_text_to_show()
	_show_text()


func _get_property_list() -> Array:
	var p := []
	var default_usage := PROPERTY_USAGE_DEFAULT|PROPERTY_USAGE_SCRIPT_VARIABLE
	
	# Text
	
	p.append({"type":TYPE_STRING, "name":"display_name", "usage":default_usage, "hint":PROPERTY_HINT_PLACEHOLDER_TEXT})
	p.append({"type":TYPE_STRING, "name":"text", "usage":default_usage, "hint":PROPERTY_HINT_MULTILINE_TEXT})
	
	# Audio
	p.append({"type":TYPE_NIL, "name":"Audio", "usage":PROPERTY_USAGE_GROUP, "hint_string":"audio_"})
	
	var blip_strategy_hint:String = ""
	for strategy in DialogManager.BlipStrategy.keys():
		blip_strategy_hint += "%s:%s,"%[strategy.capitalize(),DialogManager.BlipStrategy[strategy]]
	blip_strategy_hint = blip_strategy_hint.trim_suffix(",")
	
	p.append({"type":TYPE_INT, "name":"audio_blip_strategy", "usage":default_usage, "hint":PROPERTY_HINT_ENUM, "hint_string":blip_strategy_hint})
	
	match audio_blip_strategy:
		DialogManager.BlipStrategy.NO_BLIP:
			pass
		
		DialogManager.BlipStrategy.BLIP_ONCE, DialogManager.BlipStrategy.BLIP_LOOP:
			var audio_buses:String = ""
			for bus_idx in AudioServer.bus_count:
				audio_buses += "%s,"%AudioServer.get_bus_name(bus_idx)
			audio_buses = audio_buses.trim_suffix(",")
			
			p.append({"type":TYPE_STRING, "name":"audio_bus", "usage":default_usage, "hint":PROPERTY_HINT_ENUM, "hint_string":audio_buses})
	
			p.append({"type":TYPE_BOOL, "name":"audio_same_as_character", "usage":default_usage})
			if not audio_same_as_character:
				p.append({"type":TYPE_ARRAY, "name":"audio_blip_sounds", "hint":24, "usage":default_usage, "hint_string":"17/17:AudioStream"})
			continue
		
		DialogManager.BlipStrategy.BLIP_LOOP:
			p.append({"type":TYPE_BOOL, "name":"audio_use_space_blips", "usage":default_usage})
			if audio_use_space_blips:
				p.append({"type":TYPE_ARRAY, "name":"audio_space_blip_sounds", "hint":24, "usage":default_usage, "hint_string":"17/17:AudioStream"})
			
			p.append({"type":TYPE_INT, "name":"audio_blip_rate", "usage":default_usage, "hint":PROPERTY_HINT_RANGE, "hint_string":"1,10,1,or_greater"})
			p.append({"type":TYPE_BOOL, "name":"audio_force", "usage":default_usage})
			p.append({"type":TYPE_BOOL, "name":"audio_map_blip_to_letter", "usage":default_usage})
	
	
	p.append({"type":TYPE_STRING, "name":"translation_key", "usage":default_usage, "hint":PROPERTY_HINT_PLACEHOLDER_TEXT, "hint_string":"Same as text"})
	
	p.append({"type":TYPE_OBJECT, "name":"character", "usage":default_usage, "hint":PROPERTY_HINT_RESOURCE_TYPE, "hint_string":"Resource"})
	return p


func property_can_revert(property:String) -> bool:
	var registered_properties = []
	for p in get_property_list():
		if p["usage"] & 8199 == PROPERTY_USAGE_SCRIPT_VARIABLE:
			registered_properties.append(p["name"])
	return property in registered_properties


func property_get_revert(property:String):
	# get_property_default_value() doesn't return the default value of the script
	# so, return must be done manually
	# TODO: Open an issue about this
	# var default_value = (get_script() as Script).get_property_default_value(property)
	
	match property:
		"audio_same_as_character","audio_force":
			return true
		"audio_blip_sounds", "audio_space_blip_sounds":
			return [].duplicate()
		"audio_bus":
			return "Master"
		"translation_key", "text", "display_name":
			return ""
		"audio_use_space_blips", "audio_map_blip_to_letter":
			return false


func _init() -> void:
	event_color = Color("2892D7")
	event_name = "Text"
	event_icon = load("res://addons/textalog/assets/icons/event_icons/text_bubble.png") as Texture
	event_preview_string = "{display_name}: {text}"
	event_category = "Dialog"
	continue_at_end = false

	audio_blip_sounds = []
