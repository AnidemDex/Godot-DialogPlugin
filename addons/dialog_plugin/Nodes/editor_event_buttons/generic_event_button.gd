tool
extends Button

signal being_dragged

# must be a DialogEventResource
var event_resource:Script

func _ready() -> void:
	if not event_resource:
		return
	var event:DialogEventResource = event_resource.new() as DialogEventResource
	if not event:
		return
	var hint:String = "{event_name}\n-----\n{event_hint}"
	hint_tooltip = hint.format({"event_name":event.event_name, "event_hint":event.event_hint})
	icon = event.event_icon
	expand_icon = true
	rect_min_size = Vector2(24,24)
	


func _pressed() -> void:
	emit_signal("pressed", event_resource.new())


func get_drag_data(position):
	emit_signal("being_dragged")
	var data = event_resource.new()
	var drag_preview_node:Control = data.get_event_editor_node()
	drag_preview_node.size_flags_horizontal = Control.SIZE_FILL
	drag_preview_node.size_flags_vertical = Control.SIZE_FILL
	drag_preview_node.anchor_right = 0
	drag_preview_node.anchor_bottom = 0
	drag_preview_node.rect_size = Vector2(50,50)
	drag_preview_node.rect_min_size = Vector2(50,50)
	set_drag_preview(drag_preview_node)
	return data
