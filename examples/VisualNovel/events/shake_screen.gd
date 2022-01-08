tool
extends Event
class_name EventShakeScreen

export(float) var trauma:float = 1.0 setget _set_force
# How quickly the shaking stops [0, 1].
export(float, 0, 1) var decay:float = 0.8 setget _set_decay
# Maximum hor/ver shake in pixels.
export(Vector2) var max_offset:Vector2 = Vector2(100, 50) setget _set_offset
# Maximum rotation in radians (use sparingly).
export(float, 0, 6.3) var max_roll = 0.1 setget _set_roll

var song_name

func _init() -> void:
	event_name = "Shake Screen"
	event_color = Color("9999ff")
	event_icon = load("res://examples/VisualNovel/events/shake_screen.png") as Texture
	event_preview_string = "Shake camera with decay [{decay}], max offset [{max_offset}], max roll [{max_roll}]"
	event_hint = "Shake the main game camera"
	event_category = "VN"

func _execute() -> void:
	event_manager.get_parent().shake_screen(trauma, decay, max_offset, max_roll)
	finish()


func _set_force(value:float) -> void:
	trauma = value
	emit_changed()


func _set_decay(value:float) -> void:
	decay = value
	emit_changed()


func _set_offset(value:Vector2) -> void:
	max_offset = value
	emit_changed()


func _set_roll(value:float) -> void:
	max_roll = value
	emit_changed()
