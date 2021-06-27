tool
class_name DialogWaitTimeEvent
extends DialogEventResource

export(float, 0, 60, 1) var wait_time = 0.0

func _init():
	resource_name = "WaitTimeEvent"
	event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/wait_time_event_node/wait_time_event_node.tscn"


func execute(caller:DialogBaseNode) -> void:
	yield(caller.get_tree().create_timer(wait_time), "timeout")
	finish()
