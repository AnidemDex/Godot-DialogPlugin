tool
# class_name <your_event_class_name_here>
extends DialogEventResource

export(String, MULTILINE) var text:String = ""

func _init() -> void:
	resource_name = "Comment"
	#event_editor_scene_path = "res://path/to/your/editor/node/scene.tscn"
	skip = true


func execute(caller:DialogBaseNode) -> void:
	.execute(caller)
	finish(true)
