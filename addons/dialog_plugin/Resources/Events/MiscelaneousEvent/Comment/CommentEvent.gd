tool
# class_name <your_event_class_name_here>
extends DialogEventResource

export(String, MULTILINE) var text:String = ""

func _init() -> void:
	resource_name = "Comment"
	event_preview_string = "# {text}"
	skip = true


func execute(caller:DialogBaseNode) -> void:
	finish(true)
