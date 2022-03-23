tool
extends Node
class_name EventManager

signal custom_signal(data)

signal event_started(event)
signal event_finished(event)

signal timeline_started(timeline_resource)
signal timeline_finished(timeline_resource)

export(NodePath) var event_node_path:NodePath = "."
export(bool) var start_on_ready:bool = false

var timeline

func _ready() -> void:
	if Engine.editor_hint:
		return
	
	if start_on_ready:
		call_deferred("start_timeline")


func start_timeline(timeline_resource:Timeline=timeline) -> void:
	timeline = timeline_resource
	_notify_timeline_start()
	
	if timeline == null:
		_notify_timeline_end()
		return
	
	if timeline._event_queue.empty():
		timeline.initialize()
	
	go_to_next_event()


func go_to_next_event() -> void:
	
	if timeline == null:
		_notify_timeline_end()
		return
	
	var event = timeline.get_next_event()
	
	if event == null:
		_notify_timeline_end()
	
	_execute_event(event)


func _execute_event(event:Event) -> void:
	if event == null:
		return
	
	var node:Node = self if event_node_path == @"." else get_node(event_node_path)
	event.set("event_manager", self)
	
	_connect_event_signals(event)
	
	event.execute(node)


func _connect_event_signals(event:Event) -> void:
	if not event.is_connected("event_started", self, "_on_Event_started"):
		event.connect("event_started", self, "_on_Event_started")
	if not event.is_connected("event_finished", self, "_on_Event_finished"):
		event.connect("event_finished", self, "_on_Event_finished")


func _on_Event_started(event:Event) -> void:
	emit_signal("event_started", event)


func _on_Event_finished(event:Event) -> void:
	emit_signal("event_finished", event)
	if event.continue_at_end:
		go_to_next_event()


func _notify_timeline_start() -> void:
	emit_signal("timeline_started", timeline)


func _notify_timeline_end() -> void:
	emit_signal("timeline_finished", timeline)


func _hide_script_from_inspector():
	return true


func _get_property_list() -> Array:
	var p := []
	p.append({"type":TYPE_OBJECT, "name":"timeline", "usage":PROPERTY_USAGE_DEFAULT|PROPERTY_USAGE_SCRIPT_VARIABLE, "hint":PROPERTY_HINT_RESOURCE_TYPE, "hint_string":"Resource"})
	return p


func property_can_revert(property:String) -> bool:
	if property == "timeline":
		return true
	return false


func property_get_revert(property:String):
	if property == "timeline":
		var tmln := Timeline.new()
		return tmln
