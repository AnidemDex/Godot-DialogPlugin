extends HBoxContainer

export(NodePath) var Key_Path:NodePath
export(NodePath) var ValueContainer_Path:NodePath

var key_name:String = ""
var value
var type:int = TYPE_NIL
var type_hint:String = ""
var value_node:Control

onready var key_label:Label
onready var value_container:PanelContainer

func _ready() -> void:
	key_label.text = key_name
