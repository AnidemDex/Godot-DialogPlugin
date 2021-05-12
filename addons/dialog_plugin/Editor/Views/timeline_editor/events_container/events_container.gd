tool
extends Control

signal event_pressed(event_resource)


func _on_EventButton_pressed(event:DialogEventResource=null) -> void:
	if not event:
		return
	emit_signal("event_pressed", event)
