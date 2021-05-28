tool
extends Container

export(NodePath) var HideButton_path:NodePath
export(NodePath) var PropertiesContainer_path:NodePath

onready var hide_button_node:Button = get_node(HideButton_path) as Button
onready var properties_container:Control = get_node(PropertiesContainer_path) as Control

func _ready() -> void:
	properties_container.visible = hide_button_node.pressed
	if not hide_button_node.is_connected("toggled", self, "_on_CheckBox_toggled"):
		hide_button_node.connect("toggled", self, "_on_CheckBox_toggled")


func toggle(to_state=null) -> void:
	if not hide_button_node.disabled:
		hide_button_node.pressed = to_state if to_state != null else !hide_button_node.pressed


func _on_CheckBox_toggled(button_pressed: bool) -> void:
	properties_container.visible = button_pressed
