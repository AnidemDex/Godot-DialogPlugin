tool
extends "res://addons/dialog_plugin/Editor/Popups/NewItemPopup.gd"

export(NodePath) var TypeButton_path:NodePath

var selected_type = TYPE_MAX

onready var type_node:OptionButton = get_node(TypeButton_path) as OptionButton

func _ready() -> void:
	if type_node and type_node.has_method("generate_items"):
		type_node.generate_items()


func _on_OptionButton_item_selected(index: int) -> void:
	var metadata = type_node.get_item_metadata(index)
	if metadata:
		selected_type = metadata


func _on_visibility_changed() -> void:
	set_process(visible)
	if visible:
		text_node.text = ""
		type_node.select(0)
