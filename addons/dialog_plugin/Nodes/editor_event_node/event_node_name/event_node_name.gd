tool
extends PanelContainer

export(NodePath) var NameLabel_path:NodePath

var base_resource:DialogEventResource

onready var name_label:Label = get_node(NameLabel_path) as Label

func update_node_values() -> void:
	print_debug("Updating name")
	if base_resource:
		name_label.text = base_resource.event_name
