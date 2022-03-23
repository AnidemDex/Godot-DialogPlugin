tool
extends "res://addons/event_system_plugin/nodes/editor/event_node/event_node.gd"

signal timeline_selected(timeline)


func _draw_bottom_line() -> void:
	pass


func _on_ConditionTrue_pressed() -> void:
	var _timeline := event.get("events_if") as Timeline
	emit_signal("timeline_selected", _timeline)


func _on_ConditionFalse_pressed() -> void:
	var _timeline := event.get("events_else") as Timeline
	emit_signal("timeline_selected", _timeline)
