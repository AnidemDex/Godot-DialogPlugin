tool
extends PanelContainer

export(NodePath) var NameLabel_path:NodePath

var base_resource:DialogEventResource

onready var name_label:Label = get_node(NameLabel_path) as Label
onready var panel_style:StyleBoxFlat = get_stylebox("panel")

func update_node_values() -> void:
	if base_resource:
		name_label.text = base_resource.event_name
		panel_style.bg_color = base_resource.event_color
