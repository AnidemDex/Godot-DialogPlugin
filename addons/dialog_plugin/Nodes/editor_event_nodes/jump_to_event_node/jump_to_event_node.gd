tool
extends DialogEditorEventNode

## Use _save_resource() method everywhere you update the base_resource
## properties. Then, call again _update_node_values if you want

export(NodePath) var EventList_path:NodePath

var timeline_resource:DialogTimelineResource setget _set_timeline_resource

onready var event_list_node:OptionButton = get_node(EventList_path) as OptionButton

func _ready() -> void:
	# ALWAYS verify if you had a base_resource
	if base_resource:
		emit_signal("timeline_requested", self)


func _update_node_values() -> void:
	event_list_node.select_item_by_resource(base_resource.event_index)


func _set_timeline_resource(value:DialogTimelineResource) -> void:
	timeline_resource = value
	event_list_node.timeline_resource = value
	_update_node_values()


func _on_EventList_item_selected(index: int) -> void:
	if not base_resource:
		return
	
	if event_list_node.get_item_metadata(index):
		base_resource = base_resource as DialogJumpToEvent
		base_resource.event_index = event_list_node.get_item_metadata(index)["value"]
		_save_resource()
