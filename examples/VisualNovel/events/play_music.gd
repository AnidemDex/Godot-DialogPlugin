tool
extends Event
class_name EventPlayMusic

export(AudioStream) var song:AudioStream = null setget _set_song
export(float) var crossfade_speed:float = 1.0 setget _set_speed

var song_name

func _init() -> void:
	event_name = "Play Music"
	event_color = Color("9999ff")
	event_icon = load("res://examples/VisualNovel/events/change_music.png") as Texture
	event_preview_string = "Play song [{song_name}] with crossfade speed [{crossfade_speed}]"
	event_hint = "Change the background image"
	event_category = "VN"

func _execute() -> void:
	event_manager.get_parent().play_music(song, crossfade_speed)
	finish()


func _set_song(value:AudioStream) -> void:
	song = value
	if song != null:
		song_name = song.resource_path.get_file()
	else:
		song_name = "None"
	emit_changed()


func _set_speed(value:float) -> void:
	crossfade_speed = value
	emit_changed()
