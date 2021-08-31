tool
extends HBoxContainer

signal modified
signal remove_key(key)

export(NodePath) var Key_Path:NodePath
export(NodePath) var ValueContainer_Path:NodePath

var used_dict:Dictionary = {}
var key_name:String = ""
var value
var type:int = TYPE_NIL
var type_hint:String = ""
var value_node:Control

onready var key_label:Label = get_node(Key_Path) as Label
onready var value_container:PanelContainer = get_node(ValueContainer_Path) as PanelContainer

func _ready() -> void:
	if not used_dict.has(key_name) or key_name == "":
		_on_RemoveButton_pressed()
		queue_free()
		return
	
	value = used_dict.get(key_name)
	if type == TYPE_NIL:
		type = typeof(value)
	
	key_label.text = key_name
	generate_value_node()


func generate_value_node() -> void:
	var var_name:String = ""
	match type:
		TYPE_BOOL:
			value_node = CheckButton.new()
			var_name = "pressed"
		TYPE_OBJECT, TYPE_NIL:
			match type_hint:
				"DialogTimelineResource":
					var timeline_selector_scene:PackedScene = load("res://addons/dialog_plugin/Nodes/misc/timeline_selector/timeline_selector.tscn") as PackedScene
					value_node = timeline_selector_scene.instance() as Control
					value_node.connect("ready", value_node, "select_resource", [value], CONNECT_ONESHOT)
				_:
					var resource_selector_scene:PackedScene = load("res://addons/dialog_plugin/Nodes/misc/resource_selector/resource_selector.tscn") as PackedScene
					value_node = resource_selector_scene.instance() as Control
					var_name = "text"
					value = str(value.resource_path) if value != null else "[None]"
	
	if value_node == null:
		return
	
	value_node.set(var_name, value)
	value_node.size_flags_horizontal = SIZE_EXPAND_FILL
	value_container.add_child(value_node)



func _on_value_modified() -> void:
	used_dict[key_name] = value
	emit_signal("modified")


func _on_RemoveButton_pressed() -> void:
	emit_signal("remove_key", key_name)
