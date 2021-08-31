tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PControl

const EventDisplayer = preload("res://addons/dialog_plugin/Editor/Views/timeline_editor/events_displayer.gd")
const TimelineSelector = preload("res://addons/dialog_plugin/Nodes/misc/timeline_selector/timeline_selector.gd")

export(NodePath) var TmlnSelector_path:NodePath
export(NodePath) var PropertyName_path:NodePath

onready var property_label:Label = get_node(PropertyName_path) as Label
onready var timeline_selector:TimelineSelector = get_node(TmlnSelector_path) as TimelineSelector

func update_node_values() -> void:
	update_property_label()
	
	var timeline:DialogTimelineResource = null
	var timeline_path:String
	timeline = base_resource.get(used_property)
	timeline_selector.select_resource(timeline)


func update_property_label() -> void:
	property_label.text = used_property.capitalize()


func _on_TimelineSelector_resource_selected(resource:DialogTimelineResource) -> void:
	base_resource.set(used_property, resource)
