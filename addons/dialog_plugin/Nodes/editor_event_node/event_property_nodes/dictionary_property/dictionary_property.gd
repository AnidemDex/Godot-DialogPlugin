tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PControl

export(NodePath) var KeyContainer_Path:NodePath
export(NodePath) var NewKey_Path:NodePath

const KeyValue = preload("res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/dictionary_property/key_value/key_value.gd")

var key_value_scene:PackedScene = load("res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/dictionary_property/key_value/key_value.tscn") as PackedScene

var fixed_type:String = ""
var used_dict:Dictionary = {}

onready var key_container:Container = get_node(KeyContainer_Path) as Container
onready var new_key_text:LineEdit = get_node(NewKey_Path) as LineEdit

func update_node_values() -> void:
	update_supported_types()
	update_used_dict()
	remove_all_key_nodes()
	add_all_key_nodes()


func update_supported_types() -> void:
	$HBoxContainer/AddKeyButton.supported_types = PoolStringArray([fixed_type])
	$HBoxContainer/AddKeyButton.generate_items()


func update_used_dict() -> void:
	var _temp = base_resource.get(used_property)
	if typeof(_temp) == TYPE_DICTIONARY:
		used_dict = _temp


func remove_all_key_nodes() -> void:
	for child in key_container.get_children():
		child.queue_free()


func add_all_key_nodes() -> void:
	for key in used_dict.keys():
		add_key_node(key)


func add_key_node(key:String, forced_type:int = TYPE_NIL) -> void:
	var key_node:KeyValue = key_value_scene.instance() as KeyValue
	key_node.key_name = key
	key_node.used_dict = used_dict
	if forced_type != TYPE_NIL:
		key_node.type = forced_type
	if fixed_type != "":
		key_node.type_hint = fixed_type
	
	key_node.connect("remove_key", self, "_on_KeyNode_remove_key")
	key_container.add_child(key_node)


func _on_KeyNode_remove_key(key:String) -> void:
	used_dict.erase(key)
	base_resource.emit_changed()


func _on_AddKeyButton_item_selected(item_string:String) -> void:
	var key_name:String = new_key_text.text
	new_key_text.text = ""
	new_key_text.release_focus()
	if key_name == "":
		return
	
	var type:int = TYPE_NIL
	match item_string:
		"Bool":
			type = TYPE_BOOL
			used_dict[key_name] = false
		"String":
			type = TYPE_STRING
			used_dict[key_name] = ""
		"Int":
			type = TYPE_INT
			used_dict[key_name] = 0
		"Float":
			type = TYPE_REAL
			used_dict[key_name] = 0.0
		"Resource", "DialogTimelineResource":
			type = TYPE_OBJECT
			used_dict[key_name] = null
	
	if type == TYPE_NIL:
		return
	
	add_key_node(key_name, type)
	base_resource.emit_changed()
