tool
extends VBoxContainer

export(NodePath) var Preview_path:NodePath
export(NodePath) var Properties_path:NodePath

var base_resource:DialogEventResource
var event_index:int = -1
var is_focused:bool = false

onready var event_node_preview:Control = get_node(Preview_path) as Control
onready var event_node_properties:Control = get_node(Properties_path) as Control

onready var viewport:Viewport = get_viewport()

func _process(delta: float) -> void:
	# Hello, developer from the future. It's me Dex, trying to explain what
	# happens here (because this is an ugly method to do):
	# We mix the rect of the node with child's rects to create a bigger rect area.
	# With that area, we verify if this node has the focus, and if we are
	# draggin something.
	# Finally, we verify if the mouse is outside the event node expanded rect
	var preview_rect:Rect2 = event_node_preview.get_rect()
	var event_rect:Rect2 = event_node_properties.get_rect()
	var combined_rect:Rect2 = get_rect().merge(preview_rect).merge(event_rect)
	if is_focused and viewport.gui_is_dragging():
		if not combined_rect.has_point(get_local_mouse_position()):
			release_focus()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			update()


func _draw() -> void:
	var _focus_owner = get_focus_owner()
	if has_focus():
		_focus()
	elif _focus_owner and is_a_parent_of(_focus_owner):
		_focus()
	else:
		_unfocus()


func _focus() -> void:
	is_focused = true
	emit_signal("focus_entered", self)
	show_properties()


func _unfocus() -> void:
	is_focused = false
	emit_signal("focus_exited", self)
	hide_properties()


func update_node_values() -> void:
	if not base_resource.is_connected("changed", event_node_preview, "update_node_values"):
		base_resource.connect("changed", event_node_preview, "update_node_values")
	event_node_preview.set("base_resource", base_resource)
	event_node_preview.set("event_index", event_index)
	event_node_preview.call("update_node_values")
	
	event_node_properties.set("base_resource", base_resource)
	event_node_properties.call("update_node_values")


func show_properties() -> void:
	event_node_properties.show()
	if event_node_preview.has_method("_after_expand"):
		event_node_preview.call("_after_expand")
	if event_node_properties.has_method("_after_expand"):
		event_node_properties.call("_after_expand")


func hide_properties() -> void:
	event_node_properties.hide()
	if event_node_preview.has_method("_after_collapse"):
		event_node_preview.call("_after_collapse")
	if event_node_properties.has_method("_after_collapse"):
		event_node_properties.call("_after_collapse")


func can_drop_data(position: Vector2, data) -> bool:
	var _can_drop_data = base_resource.get("can_drop_data")
	if _can_drop_data:
		grab_focus()
		update()
	return false
