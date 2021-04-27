tool
extends Control

signal event_pressed(event_resource)

onready var event_buttons_container = $HBoxContainer/PanelContainer/EventButtons
onready var checkbox = $HBoxContainer/CheckBox

func _ready() -> void:
	if checkbox.pressed:
		_show_toolbar()
	else:
		_hide_toolbar()


func _show_toolbar() -> void:
	event_buttons_container.visible = true


func _hide_toolbar() -> void:
	event_buttons_container.visible = false


func _on_EventButton_pressed(event:DialogEventResource=null) -> void:
	if not event:
		return
	emit_signal("event_pressed", event)


func _on_CheckBox_toggled(button_pressed: bool) -> void:
	if button_pressed:
		_show_toolbar()
	else:
		_hide_toolbar()
