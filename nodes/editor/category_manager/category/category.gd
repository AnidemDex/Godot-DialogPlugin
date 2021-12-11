tool
extends PanelContainer

signal event_pressed(event_script)

export(NodePath) var CategoryNamePath:NodePath
export(NodePath) var EventContainerPath:NodePath

var category:String = ""
var events:Array = []

onready var category_name:Label = get_node(CategoryNamePath) as Label
onready var event_container:Control = get_node(EventContainerPath) as Control

var _Event = load("res://addons/event_system_plugin/resources/event_class/event_class.gd")

func _init() -> void:
	events = []


func _fake_ready() -> void:
	update_values()


func update_values() -> void:
	category_name.text = category


func add_event(event:Resource) -> void:
	
	if not(event is _Event):
		return
	
	var event_script:Script = event.get_script()
	if event_script in events:
		return
	
	var event_button:Button = Button.new()
	event_button.set_meta("event_script", event_script)
	
	event_button.set_drag_forwarding(self)
	
	event_button.connect("pressed", self, "emit_signal", ["event_pressed", event_script])
	
	event_button.icon = event.get("event_icon")
	event_button.expand_icon = true
	event_button.clip_text = true
	
	event_button.size_flags_vertical = SIZE_EXPAND_FILL
	event_button.rect_min_size = Vector2(24,24)
	
	var event_hint := "{event_name}\n-----\n{event_hint}"
	event_button.hint_tooltip = event_hint.format({"event_name":event.get("event_name"), "event_hint":event.get("event_hint")})
	
	event_container.add_child(event_button)
	
	events.append(event_script)
	
	event = null


func get_drag_data_fw(position: Vector2, node):
	var event_script = node.get_meta("event_script")
	var event = event_script.new()
	var event_node_scene = load("res://addons/event_system_plugin/nodes/editor/event_node/event_node.tscn")
	var event_node = event_node_scene.instance()
	set_drag_preview(event_node)
	event_node.set("event", event)
	event_node.set("event_index", -1)
	event_node.call("_update_values")
	
	return event
