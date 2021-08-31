tool
extends HBoxContainer

signal resource_selected(resource)

const EventDisplayer = preload("res://addons/dialog_plugin/Editor/Views/timeline_editor/events_displayer.gd")

export(NodePath) var ResourceSelector_Path:NodePath
export(NodePath) var EventDisplayer_Path:NodePath
export(NodePath) var TimelineContainer_path:NodePath

onready var resource_selector:Button = get_node(ResourceSelector_Path) as Button
onready var event_displayer:EventDisplayer = get_node(EventDisplayer_Path) as EventDisplayer
onready var timeline_container:Container = get_node(TimelineContainer_path) as Container

func _ready() -> void:
	resource_selector.set_drag_forwarding(self)


func can_drop_data_fw(position: Vector2, data, from_node:Control) -> bool:
	return data is DialogEventResource


func drop_data_fw(position: Vector2, data, from_node:Control) -> void:
	var new_timeline := DialogTimelineResource.new()
	select_resource(new_timeline)
	event_displayer.call_deferred("add_event", data)
	emit_signal("resource_selected", new_timeline)
	show_timeline()


func hide_timeline() -> void:
	timeline_container.hide()


func show_timeline() -> void:
	timeline_container.show()


func select_resource(resource:Resource) -> void:
	if resource == null:
		hide_timeline()
		return
	
	if "::" in resource.resource_path or resource.resource_path == "":
		show_timeline()
	
	resource_selector.text = resource.resource_path
	event_displayer.unload_events()
	event_displayer.timeline_resource = resource
	event_displayer.call_deferred("load_events")


func _on_ResourceSelector_resource_selected(resource:DialogTimelineResource) -> void:
	hide_timeline()
	select_resource(resource)
	emit_signal("resource_selected", resource)
