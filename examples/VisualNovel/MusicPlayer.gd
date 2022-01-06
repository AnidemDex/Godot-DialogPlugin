extends AudioStreamPlayer


onready var effects_player = $EffectsPlayer
onready var crossfade_player = $CrossfadePlayer

var current_song: AudioStream setget set_song, get_song

func play_music(song: AudioStream, speed = 1.0):
	# first song played or no crossfade asked of us, skip crossfade
	if stream == null or speed <= 0:
		stream = song
		volume_db = 0
		crossfade_player.volume_db = -80
		play()
		return
	if volume_db > crossfade_player.volume_db:
		crossfade_player.stream = song
		crossfade_player.play()
		effects_player.play("crossfade", -1, speed)
	else:
		stream = song
		play()
		effects_player.play("crossfade", -1, -speed, true)


func set_song(value: AudioStream):
	if volume_db > crossfade_player.volume_db:
		stream = value
	else:
		crossfade_player.stream = value


func get_song():
	if volume_db > crossfade_player.volume_db:
		return stream
	return crossfade_player.stream
