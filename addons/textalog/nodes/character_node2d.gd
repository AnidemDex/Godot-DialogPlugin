tool
extends Sprite

var character:Resource
var dialog_node_path:NodePath

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
	
	var dialog_node:Node = get_dialog_node()
	say(what)
	
	for option in options:
		dialog_node.call("add_option", option)


func get_dialog_node() -> Node:
	return get_node_or_null(dialog_node_path)


func has_dialog_node() -> bool:
	return is_instance_valid(get_dialog_node())


func _option_selected(option:String) -> void:
	return


func _configure() -> void:
	if has_dialog_node():
		var dialog_node:Node = get_dialog_node()
		dialog_node.connect("option_selected", self, "_option_selected")
	else:
		push_warning("Can't configure dialog node for character")


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if not Engine.editor_hint:
				get_parent().connect("ready", self, "_configure", [], CONNECT_ONESHOT)
		
		NOTIFICATION_READY:
			if not character:
				push_error("{name} doesn't have any character".format({"name":name}))


func _get_property_list() -> Array:
	var p:Array = []
	p.append({"name":"dialog_node_path", "type":TYPE_NODE_PATH})
	p.append({"name":"character", "type":TYPE_OBJECT})
	return p
