tool
extends Control

signal event_pressed(event_resource)

func _ready() -> void:
	if $CheckBox.pressed:
		_show_toolbar()
	else:
		_hide_toolbar()


func _show_toolbar() -> void:
	$EventButtons.visible = true


func _hide_toolbar() -> void:
	$EventButtons.visible = false


func _on_EventButton_pressed(event:DialogEventResource=null) -> void:
	if not event:
		return
	emit_signal("event_pressed", event)


func _on_CheckBox_toggled(button_pressed: bool) -> void:
	if button_pressed:
		_show_toolbar()
	else:
		_hide_toolbar()
