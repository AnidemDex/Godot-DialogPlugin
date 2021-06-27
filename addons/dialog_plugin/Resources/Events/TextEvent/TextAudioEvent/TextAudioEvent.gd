tool
class_name DialogTextWithAudioEvent
extends DialogTextEvent

export(AudioStream) var blip_sound:AudioStream
export(bool) var loop_blip_sound:bool = false
export(bool) var force_blip_sound:bool = false

var sound_generator:AudioStreamPlayer

var _already_played:bool = false

func _init() -> void:
	# Uncomment resource_name line if you want to display a name in the editor
	resource_name = "TextWithAudio"
	text_speed = 0.04

	# Uncomment event_editor_scene_path line and replace it with your custom DialogEditorEventNode scene
	#event_editor_scene_path = "res://path/to/your/editor/node/scene.tscn"


func prepare_sound_generator():
	if not is_instance_valid(sound_generator):
		sound_generator = get_sound_generator_instance()
	
	if not sound_generator.is_inside_tree():
		_caller.add_child(sound_generator)
	
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


func _on_TextTimer_timeout() -> void:
	prepare_sound_generator()
	_update_text()
	if not _already_played:
		_blip()
		_already_played = _will_loop()


func finish(_s=skip) -> void:
	if is_instance_valid(sound_generator):
		sound_generator.queue_free()
	.finish(skip)
