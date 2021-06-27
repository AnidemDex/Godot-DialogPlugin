tool
# class_name <your_event_class_name_here>
extends DialogEventResource

export(String, MULTILINE) var text:String = ""

func _init() -> void:
	resource_name = "Comment"
	event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/comment_event_node/comment_event_node.tscn"
	skip = true


func execute(caller:DialogBaseNode) -> void:
	finish(true)
