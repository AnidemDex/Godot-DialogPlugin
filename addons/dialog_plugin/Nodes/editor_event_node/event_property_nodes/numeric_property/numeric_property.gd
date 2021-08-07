tool
extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PControl

var step:float = 1.0

onready var spinbox:SpinBox = $SpinBox as SpinBox
onready var label:Label = $Label as Label

func _ready() -> void:
	spinbox.step = step

func update_node_values() -> void:
	label.text = used_property.capitalize()
	var value:float = float(base_resource.get(used_property))
	spinbox.value = value

func _on_SpinBox_value_changed(value: float) -> void:
	base_resource.set(used_property, value)
