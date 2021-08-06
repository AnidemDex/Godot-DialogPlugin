tool
class_name DialogTextWithAudioEvent
extends DialogTextEvent

export(AudioStream) var blip_sound:AudioStream = null setget set_sound
export(bool) var loop_blip_sound:bool = false setget set_loop_sound_bool
export(bool) var force_blip_sound:bool = false setget force_blip
export(String) var audio_bus:String = "Master" setget set_audio_bus

var sound_generator:AudioStreamPlayer

var _already_played:bool = false

func _init() -> void:
	# Uncomment resource_name line if you want to display a name in the editor
	resource_name = "TextWithAudio"
	event_name = "Text With Audio"
	event_icon = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/text/text_w_sound_bubble.png") as Texture
	text_speed = 0.04


func execute(caller:DialogBaseNode) -> void:
	prepare_sound_generator()
	.execute(caller)
	if _DialogNode:
		_DialogNode.connect("character_displayed", self, "_on_DialogManager_character_displayed")


func prepare_sound_generator():
	if not is_instance_valid(sound_generator):
		sound_generator = get_sound_generator_instance()
	
	if not sound_generator.is_inside_tree():
		_caller.add_child(sound_generator)
	
	sound_generator.bus = audio_bus
	sound_generator.stream = get_blip_sound()


func get_blip_sound() -> AudioStream:
	return blip_sound


func get_sound_generator_instance() -> AudioStreamPlayer:
	var _instance:AudioStreamPlayer = AudioStreamPlayer.new()
	return _instance


func _blip() -> void:
	if not sound_generator.is_playing() or force_blip_sound:
		sound_generator.play()


func _will_loop() -> bool:
	return !loop_blip_sound


func _on_DialogManager_character_displayed(character) -> void:
	if not _already_played:
		_blip()
		_already_played = _will_loop()


func finish(_s=skip) -> void:
	if is_instance_valid(sound_generator):
		sound_generator.queue_free()
	if _DialogNode:
		_DialogNode.disconnect("character_displayed", self, "_on_DialogManager_character_displayed")
	.finish(skip)


func set_sound(value:AudioStream) -> void:
	blip_sound = value
	emit_changed()


func set_loop_sound_bool(value:bool) -> void:
	loop_blip_sound = value
	emit_changed()

func force_blip(value:bool) -> void:
	force_blip_sound = value
	emit_changed()

func set_audio_bus(value:String) -> void:
	audio_bus = value if value != "" else "Master"
	emit_changed()
