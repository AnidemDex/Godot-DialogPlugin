tool
extends Node

var character:Resource setget set_character
var portrait:String
var dialog_node_path:NodePath setget set_node_path

func say(what:String) -> void:
	if not has_dialog_node():
		push_error("say: Can't find dialog node at {path}".format({"path":dialog_node_path}))
		return
	
	var dialog_node:Node = get_dialog_node()
	
	dialog_node.call("set_current_speaker", self)
	dialog_node.call("show_text", what)


func ask(what:String, options:PoolStringArray) -> void:
	if not has_dialog_node():
		push_error("ask: Can't find dialog node at {path}".format({"path":dialog_node_path}))
		return
	
	var dialog_node:Node = get_dialog_node()
	
	if not dialog_node.is_connected("option_selected", self, "_option_selected"):
		dialog_node.connect("option_selected", self, "_option_selected", [], CONNECT_ONESHOT)
	
	dialog_node.connect("text_all_displayed", self, "_add_options", [dialog_node, options], CONNECT_ONESHOT|CONNECT_DEFERRED)
	say(what)


func join() -> void:
	pass

func leave() -> void:
	pass

func change_portrait(to:String) -> void:
	pass

func get_dialog_node() -> Node:
	return get_node_or_null(dialog_node_path)


func has_dialog_node() -> bool:
	return is_instance_valid(get_dialog_node())


func set_character(value:Resource) -> void:
	character = value
	
	if character:
		name = character.get("name")
	else:
		name = "Character2D"


func set_node_path(path:NodePath) -> void:
	dialog_node_path = path


func _add_options(shown_text:String, dialog_node:Node, options:PoolStringArray) -> void:
	for option in options:
		dialog_node.call("add_option", option)


func _option_selected(option:String) -> void:
	return


func _configure() -> void:
	if has_dialog_node():
		var dialog_node:Node = get_dialog_node()
		dialog_node.register_node_for_character(self)
	else:
		if not Engine.editor_hint:
			push_warning("Can't configure dialog node for character")


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			get_parent().connect("ready", self, "_configure", [], CONNECT_ONESHOT)
		
		NOTIFICATION_READY:
			if not Engine.editor_hint:
				if not character:
					push_error("{name} doesn't have any character".format({"name":name}))
					return


func _get_property_list() -> Array:
	var p:Array = []
	p.append({"name":"dialog_node_path", "type":TYPE_NODE_PATH})
	p.append({"name":"character", "type":TYPE_OBJECT, "hint":PROPERTY_HINT_RESOURCE_TYPE})
	return p

