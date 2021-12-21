tool
extends Event
class_name EventCallFrom

export(NodePath) var node_path:NodePath setget set_node_path
export(String) var method:String = "" setget set_method
export(Array) var args:Array = []

func _init() -> void:
	event_color = Color("5AA0EB")
	event_name = "Call From"
	event_category = "Node"
	event_icon = load("res://addons/event_system_plugin/assets/icons/event_icons/call.png") as Texture
	event_preview_string = "{node_path} {method} ( {args} ) "

	args = []


func _execute() -> void:
	var node = event_node.get_tree().current_scene.get_node_or_null(node_path)
	if node != null:
		node.callv(method, args)
	finish()

func set_node_path(value:NodePath) -> void:
	node_path = value
	emit_changed()
	property_list_changed_notify()
	
func set_method(value:String) -> void:
	method = value
	emit_changed()
	property_list_changed_notify()


func set_args(value:Array) -> void:
	args = value.duplicate()
	emit_changed()
	property_list_changed_notify()
