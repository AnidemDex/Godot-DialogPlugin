tool
extends Button

signal being_dragged

# must be a DialogEventResource
var event_resource:Script

var event_node_template_scene:PackedScene = preload("res://addons/dialog_plugin/Nodes/editor_event_node/event_node_template.tscn")

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
	var drag_preview_node:Control = event_node_template_scene.instance() as Control
	drag_preview_node.set("base_resource", data)
	drag_preview_node.set("event_index", -1)
	
	drag_preview_node.size_flags_horizontal = Control.SIZE_FILL
	drag_preview_node.size_flags_vertical = Control.SIZE_FILL
	drag_preview_node.anchor_right = 0
	drag_preview_node.anchor_bottom = 0
	drag_preview_node.rect_size = Vector2(50,50)
	drag_preview_node.rect_min_size = Vector2(50,50)
	
	set_drag_preview(drag_preview_node)
	drag_preview_node.call("update_event_node_values")
	return data
