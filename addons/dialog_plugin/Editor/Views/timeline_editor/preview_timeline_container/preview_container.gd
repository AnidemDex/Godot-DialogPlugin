tool
extends PanelContainer

export(NodePath) var DialogNode_path:NodePath

var base_resource:DialogTimelineResource
var displayed_event:DialogEventResource

onready var dialog_node:DialogBaseNode = get_node(DialogNode_path) as DialogBaseNode

func preview_event(event:DialogEventResource) -> void:
	displayed_event = event
	var _events:Array = (base_resource as DialogTimelineResource).events
	var _event_idx:int = _events.find(displayed_event)
	base_resource.current_event = clamp(_event_idx, 0, _events.size())
	dialog_node.timeline = base_resource
	dialog_node.start_timeline()
