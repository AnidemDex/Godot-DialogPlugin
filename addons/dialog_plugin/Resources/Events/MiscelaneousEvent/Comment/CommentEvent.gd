tool
class_name _DialogEventComment
extends DialogMiscelaneousEvent

export(String, MULTILINE) var text:String = "" setget set_text

func _init() -> void:
	resource_name = "Comment"
	event_preview_string = "# {text}"
	event_icon = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/misc/comment_event.png") as Texture
	skip = true


func execute(caller:DialogBaseNode) -> void:
	finish(true)

func set_text(value:String) -> void:
	text = value
	property_list_changed_notify()
	emit_changed()

func _get(property: String):
	if property == "skip_disabled":
		return true
