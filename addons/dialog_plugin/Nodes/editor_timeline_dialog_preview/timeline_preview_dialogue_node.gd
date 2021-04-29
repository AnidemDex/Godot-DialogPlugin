tool
extends DialogBaseNode

func _ready() -> void:
	next_input = ""

func _on_event_finished(_event, go_to_next_event=false):
	# Avoid going to next event if it's not intended
	pass
