tool
class_name DialogJumpToEvent
extends DialogEventResource

export(int) var event_index:int = -1

func _init() -> void:
	resource_name = "JumpToEvent"
	event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/jump_to_event_node/jump_to_event_node.tscn"
	skip = true


func execute(caller:DialogBaseNode) -> void:
	
	if event_index >= 0:
		var _timeline:DialogTimelineResource = caller.timeline
		_timeline.current_event = max(-1, event_index-1)

	# Notify that you end this event
	finish()
