tool
extends Event
class_name EventChangeBackground

export(Texture) var background:Texture = null setget _set_background
export(Texture) var transition:Texture = null setget _set_transition
export(float, 0, 1) var smooth:float = 0.5 setget _set_smooth
export(float) var transition_speed:float = 1.0 setget _set_speed

var bg_name
var tr_name

func _init() -> void:
	event_name = "Change Background"
	event_color = Color("9999ff")
	event_icon = load("res://examples/VisualNovel/events/change_background.png") as Texture
	event_preview_string = "Change background to [{bg_name}] using screen transition [{tr_name}] with [{smooth}] smoothness and [{transition_speed}] speed"
	event_hint = "Change the background image"
	event_category = "VN"

func _execute() -> void:
	event_manager.get_parent().set_background(background, smooth, transition_speed)
	finish()


func _set_background(value:Texture) -> void:
	background = value
	if background != null:
		bg_name = background.resource_path.get_file()
	else:
		bg_name = "None"
	emit_changed()


func _set_transition(value:Texture) -> void:
	transition = value
	if transition != null:
		tr_name = transition.resource_path.get_file()
	else:
		tr_name = "None"
	emit_changed()


func _set_smooth(value:float) -> void:
	smooth = value
	emit_changed()


func _set_speed(value:float) -> void:
	transition_speed = value
	emit_changed()
