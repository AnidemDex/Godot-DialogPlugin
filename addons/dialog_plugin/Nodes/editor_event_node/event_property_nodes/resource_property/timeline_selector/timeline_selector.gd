tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PControl

const EventDisplayer = preload("res://addons/dialog_plugin/Editor/Views/timeline_editor/events_displayer.gd")

export(NodePath) var EventDisplayer_path:NodePath
export(NodePath) var TmlnSelector_path:NodePath
export(NodePath) var PropertyName_path:NodePath
export(NodePath) var TimelineContainer_path:NodePath

onready var property_label:Label = get_node(PropertyName_path) as Label
onready var timeline_selector:Button = get_node(TmlnSelector_path) as Button
onready var event_displayer:EventDisplayer = get_node(EventDisplayer_path) as EventDisplayer
onready var timeline_container:Container = get_node(TimelineContainer_path) as Container

func update_node_values() -> void:
	update_property_label()
	
	var timeline:DialogTimelineResource = null
	var timeline_path:String
	timeline = base_resource.get(used_property)
	if timeline:
		timeline_path = timeline.resource_path
		if "::" in timeline_path:
			event_displayer.timeline_resource = timeline
			event_displayer.force_reload()
			show_timeline()
		else:
			event_displayer.timeline_resource = null
			event_displayer.unload_events()
			hide_timeline()
	else:
		push_error("For some reason, this property '{0}' doesn't had any timeline".format([used_property]))


func update_property_label() -> void:
	property_label.text = used_property.capitalize()


func hide_timeline() -> void:
	timeline_container.hide()

func show_timeline() -> void:
	timeline_container.show()


func _on_ResourceSelector_resource_selected(resource:Resource) -> void:
	if resource is DialogTimelineResource:
		base_resource.set(used_property, resource)
		hide_timeline()
	if resource == null:
		base_resource.set(used_property, DialogTimelineResource.new())
		show_timeline()
