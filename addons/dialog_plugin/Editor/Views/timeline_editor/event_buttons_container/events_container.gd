tool
extends Control

signal event_pressed(event_resource)

func _on_EventsContainer_event_pressed(event:DialogEventResource) -> void:
	if not event:
		return
	emit_signal("event_pressed", event)
