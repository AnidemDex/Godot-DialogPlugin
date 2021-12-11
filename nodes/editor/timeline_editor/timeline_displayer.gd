tool
extends VBoxContainer

signal event_node_added(event_node)

const _EventNode = preload("res://addons/event_system_plugin/nodes/editor/event_node/event_node.gd")

var event_node_scene:PackedScene = load("res://addons/event_system_plugin/nodes/editor/event_node/event_node.tscn") as PackedScene

var _events_to_load:Array = []

var _timeline:Timeline = null

func load_timeline(timeline:Timeline) -> void:
	_timeline = timeline
	_events_to_load = _timeline.get_events()
	set_meta("start", OS.get_unix_time())
	_load_events()

func reload() -> void:
	set_meta("start", OS.get_unix_time())
	_unload_events()
	if not _timeline:
		return
	_events_to_load = _timeline.get_events()
	_load_events()


func _load_events() -> void:
	var event:Event = _events_to_load.pop_front()
	if event == null:
		set_meta("end", OS.get_unix_time())
#		print_debug("Took: ", get_meta("end")-get_meta("start"))
		return
	
	var event_node:_EventNode = event.get("custom_event_node") as _EventNode
	if not event_node:
		event_node = event_node_scene.instance() as _EventNode
		
	event_node.event = event
	event_node.event_index = _timeline.get_events().find(event)
	event_node.connect("ready", event_node, "_fake_ready")
	event_node.connect("ready", self, "_load_events", [], CONNECT_ONESHOT)
	event_node.connect("ready", self, "emit_signal", ["event_node_added", event_node], CONNECT_ONESHOT)
	add_child(event_node)


func _unload_events() -> void:
	for child in get_children():
		child.queue_free()
