tool
extends "res://addons/event_system_plugin/resources/timeline_class/timeline_class.gd"

func _init():
	_events = [
		load("res://addons/event_system_plugin/events/call_from.gd").new(),
		load("res://addons/event_system_plugin/events/comment.gd").new(),
		load("res://addons/event_system_plugin/events/emit_signal.gd").new(),
		load("res://addons/event_system_plugin/events/end_timeline.gd").new(),
		load("res://addons/event_system_plugin/events/hide.gd").new(),
		load("res://addons/event_system_plugin/events/new_condition.gd").new(),
		load("res://addons/event_system_plugin/events/set.gd").new(),
		load("res://addons/event_system_plugin/events/show.gd").new(),
		load("res://addons/event_system_plugin/events/wait.gd").new(),
		load("res://addons/event_system_plugin/events/goto.gd").new()
		]
