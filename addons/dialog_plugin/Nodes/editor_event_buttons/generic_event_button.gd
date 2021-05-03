tool
extends Button

# must be a DialogEventResource
export (Resource) var event_resource:Resource

onready var tween_node = $Tween


func _pressed() -> void:
	emit_signal("pressed", event_resource.get_script().new())


func get_drag_data(position):
	var data = event_resource.get_script().new()
	var drag_preview_node:Control = data.get_event_editor_node()
	drag_preview_node.size_flags_horizontal = Control.SIZE_FILL
	drag_preview_node.size_flags_vertical = Control.SIZE_FILL
	drag_preview_node.anchor_right = 0
	drag_preview_node.anchor_bottom = 0
	drag_preview_node.rect_size = Vector2(50,50)
	drag_preview_node.rect_min_size = Vector2(50,50)
	set_drag_preview(drag_preview_node)
	return data

func expand() -> void:
	var _font = get_font("font")
	var _offset = rect_size + Vector2(10,0)
	var _text_size = _font.get_string_size(text) + _offset
	_text_size = Vector2(_text_size.x, 0)
	tween_node.interpolate_property(
		self, 
		"rect_size", 
		Vector2.ZERO, _text_size,
		0.1, Tween.TRANS_BOUNCE, Tween.EASE_IN)
	if tween_node.is_active():
		yield(tween_node, "tween_all_completed")
	tween_node.start()


func contract() -> void:
	tween_node.interpolate_property(
		self, 
		"rect_min_size", 
		rect_size, Vector2.ZERO,
		0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	if tween_node.is_active():
		yield(tween_node, "tween_all_completed")
	tween_node.start()


func _on_mouse_entered() -> void:
	expand()


func _on_mouse_exited() -> void:
	contract()


func _on_Tween_completed(object: Object, key: NodePath) -> void:
	rect_min_size = rect_size
