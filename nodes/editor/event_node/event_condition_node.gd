tool
extends "res://addons/event_system_plugin/nodes/editor/event_node/event_node.gd"

class ElseEvent extends Event:
	
	class ElseNode extends "res://addons/event_system_plugin/nodes/editor/event_node/event_node.gd":		
		func _ready():
			event_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			event_button.focus_mode = Control.FOCUS_NONE
		
		
		func _update_values() -> void:
			add_subtimeline(event.timeline)
	
	
	var timeline
	
	func _init() -> void:
		event_name = "Else"
		event_color = Color.darkolivegreen
	
	func _get(property: String):
		if property == "custom_event_node":
			return ElseNode.new()


var dummy = ElseEvent.new()
func _update_values() -> void:
	event = event as EventCondition
	
	var if_timeline = event.get_if_timeline()
	if if_timeline:
		add_subtimeline(if_timeline)
	
	
	var else_timeline = event.get_else_timeline()
	if else_timeline:
		dummy.timeline = else_timeline
		add_subevent(dummy)
	
#	assert(if_timeline != else_timeline, "For some reason, both timelines are the same. Ignore this error if is intended")
