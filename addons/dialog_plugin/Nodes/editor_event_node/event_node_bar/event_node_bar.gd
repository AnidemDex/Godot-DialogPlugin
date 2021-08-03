tool
extends VBoxContainer

export(NodePath) var Preview_path:NodePath
export(NodePath) var Properties_path:NodePath

var base_resource:DialogEventResource
var event_index:int = -1
var is_focused:bool = false

onready var event_node_preview:Control = get_node(Preview_path) as Control
onready var event_node_properties:Control = get_node(Properties_path) as Control

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
