tool
extends Control

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")

export(NodePath) var TimelineEventsContainer_path:NodePath
export(NodePath) var TimelinePreview_path:NodePath

var base_resource:DialogTimelineResource setget _set_base_resource
var selected_event_idx:int = 0
var event_nodes:Dictionary = {}

onready var timeline_events_container_node = get_node_or_null(TimelineEventsContainer_path)
onready var timeline_preview_node := get_node(TimelinePreview_path)

func _ready() -> void:
	if not base_resource:
		return
	timeline_preview_node.base_resource = base_resource
	selected_event_idx = base_resource.events.get_resources().size()-1
	_load_events()


func _draw() -> void:
	if not visible:
		_unload_events()


func add_event(event_resource:DialogEventResource) -> void:
	var events:Array = base_resource.events.get_resources()
	selected_event_idx += 1
#	selected_event_idx = clamp(selected_event_idx, 0, events.size())
	events.insert(selected_event_idx, event_resource)
	var _err = ResourceSaver.save(base_resource.resource_path, base_resource)
	assert(_err == OK)
	_load_events()


func _unload_events():
	for child in timeline_events_container_node.get_children():
		child.queue_free()


func _load_events() -> void:
	_unload_events()
	var _idx = 0

	for event in base_resource.events:
		DialogUtil.Logger.print(self,["Trying to load event's node in:", event.resource_path])
		var event_node:DialogEditorEventNode = (event as DialogEventResource).get_event_editor_node()
		var _err = event_node.connect("delelete_item_requested", self, "_on_EventNode_deletion_requested")
		assert(_err == OK)
		_err = event_node.connect("save_item_requested", self, "_on_EventNode_save_requested")
		assert(_err == OK)
		_err = event_node.connect("item_selected", self, "_on_EventNode_event_selected")
		assert(_err == OK)
		_err = event_node.connect("item_dragged", self, "_on_EventNode_event_dragged")
		assert(_err == OK)
		timeline_events_container_node.add_child(event_node)
		event_nodes[_idx] = event_node
		event_node.idx = _idx
		_idx += 1
	
	if selected_event_idx != -1:
		event_nodes[selected_event_idx].call_deferred("grab_focus")


func _set_base_resource(_r:DialogTimelineResource) -> void:
	if not _r:
#		push_error("No resource")
		return

	base_resource = _r
	DialogUtil.Logger.print(self,["Using {res} at {path}".format({"res":base_resource.get_class(), "path":_r.resource_path})])


func _on_EventButtonsContainer_event_pressed(event_resource:DialogEventResource) -> void:
	if not base_resource:
		return
	add_event(event_resource)


func _on_TimelineEventsContainer_item_added(event_resource:DialogEventResource):
	if not base_resource:
		return
	add_event(event_resource)


func _on_EventNode_deletion_requested(event) -> void:
	var _events:Array = (base_resource as DialogTimelineResource).events.get_resources()
	var _event_idx = _events.find(event)
	if _event_idx == -1:
		selected_event_idx == _events.size()-1
	else:
		selected_event_idx = _event_idx - 1
	_events.erase(event)
	var _err = ResourceSaver.save(base_resource.resource_path, base_resource, ResourceSaver.FLAG_CHANGE_PATH)
	assert(_err == OK)
	_load_events()


func _on_EventNode_save_requested(event:DialogEventResource) -> void:
	var _events:ResourceArray = base_resource.events
	var _events_array:Array = _events.get_resources()
#	assert(event in _events_array)
	var _idx = _events_array.find(event)
	if _idx != -1:
		assert(_events_array[_idx] == event)
		
#	var _err = ResourceSaver.save(_resource.resource_path, _resource)
#	assert(_err == OK)


func _on_EventNode_event_selected(event:DialogEventResource) -> void:
	selected_event_idx = (base_resource.events.get_resources() as Array).find(event)
	timeline_preview_node.preview_event(event)


func _on_EventNode_event_dragged(event:DialogEventResource, idx:int, new_idx:int, update_view=false) -> void:
	var placeholder:Control = PanelContainer.new()
	var event_node:Control = event_nodes[idx]
	var _n_idx = clamp(idx+new_idx, 0, event_nodes.keys().size()-1)
	event_node.get_parent().move_child(event_node, _n_idx)
	
	if update_view:
		if new_idx != 0:
			base_resource.events.get_resources().erase(event)
			base_resource.events.get_resources().insert(_n_idx, event)
			selected_event_idx = _n_idx
		_load_events()
