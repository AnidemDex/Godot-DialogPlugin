tool
extends VBoxContainer

signal event_button_pressed(event)

const EventButton = preload("res://addons/dialog_plugin/Nodes/editor_event_buttons/generic_event_button.gd")
const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")

export(NodePath) var NameLabel_path:NodePath
export(NodePath) var EventContainer_path:NodePath

onready var name_label:Label = get_node(NameLabel_path) as Label
onready var event_buttons_container:Container = get_node(EventContainer_path)

var category_name:String = ""
var category_events:PoolStringArray = PoolStringArray([])
var event_button_scene:PackedScene = load("res://addons/dialog_plugin/Nodes/editor_event_buttons/generic_event_button.tscn") as PackedScene

func _ready() -> void:
	name_label.text = category_name


func generate_buttons_from_events() -> void:	
	for event_property in category_events:
		var event_path = ProjectSettings.get_setting(event_property)
		var event_script:Script = load(event_path) as Script
		if not event_script:
			continue
		var event_button:EventButton = event_button_scene.instance() as EventButton
		event_button.event_resource = event_script
		event_button.connect("pressed", self, "_on_EventButton_pressed")
		DialogUtil.Logger.print_debug(self, "Adding event for "+event_path)
		add_event_button(event_button)


func add_event_button(event_button:Button) -> void:
	event_buttons_container.add_child(event_button)


func _on_EventButton_pressed(event:DialogEventResource=null) -> void:
	if not event:
		return
	emit_signal("event_button_pressed", event)
