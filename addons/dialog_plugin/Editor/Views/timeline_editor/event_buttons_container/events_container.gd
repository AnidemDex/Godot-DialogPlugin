tool
extends Control

signal event_pressed(event_resource)
signal event_being_dragged


func _on_EventButton_pressed(event:DialogEventResource=null) -> void:
	if not event:
		return
	emit_signal("event_pressed", event)


func _on_EventButton_being_dragged() -> void:
	emit_signal("event_being_dragged")
