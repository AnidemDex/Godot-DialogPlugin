tool
# class_name <your_event_class_name_here>
extends DialogEventResource

export(String, MULTILINE) var text:String = ""

func _init() -> void:
	resource_name = "Comment"
	event_preview_string = "# {text}"
	event_icon = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/misc/comment_event.png") as Texture
	skip = true


func execute(caller:DialogBaseNode) -> void:
	finish(true)
