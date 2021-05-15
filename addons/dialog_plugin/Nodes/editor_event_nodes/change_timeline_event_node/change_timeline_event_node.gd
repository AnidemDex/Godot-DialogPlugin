tool
extends DialogEditorEventNode

## Use _save_resource() method everywhere you update the base_resource
## properties. Then, call again _update_node_values if you want

export(NodePath) var TimelineList_path:NodePath

var timeline_resource:DialogTimelineResource setget _set_timeline

onready var timeline_list_node:OptionButton = get_node(TimelineList_path) as OptionButton

func _ready() -> void:
	# ALWAYS verify if you had a base_resource
	if base_resource:
		# You can prepare your nodes here before updating its values
		emit_signal("timeline_requested",self)


func _update_node_values() -> void:
	timeline_list_node.select_item_by_resource(base_resource.timeline)


func _set_timeline(value:DialogTimelineResource) -> void:
	timeline_resource = value
	timeline_list_node.timeline = value
	_update_node_values()


func _on_TimelineList_item_selected(index: int) -> void:
	if not base_resource:
		return
	
	if timeline_list_node.get_item_metadata(index):
		base_resource = base_resource as DialogChangeTimelineEvent
		var metadata = timeline_list_node.get_item_metadata(index)["timeline"]
		base_resource.timeline = metadata
		_save_resource()
