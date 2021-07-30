tool
extends PanelContainer

export(NodePath) var PreviewLabel_path:NodePath
export(NodePath) var Index_path:NodePath

var base_resource:DialogEventResource
var event_index:int = -1

onready var preview_label:Label = get_node(PreviewLabel_path) as Label
onready var index_label:Label = get_node(Index_path) as Label

onready var panel_stylebox:StyleBoxFlat = get_stylebox("panel")

func update_node_values() -> void:
	print_debug("Updating preview")
	preview_label.text = base_resource.event_preview_string if base_resource else ""
	index_label.text = str(event_index)

func _after_expand() -> void:
	if base_resource:
		panel_stylebox.bg_color = base_resource.event_color

func _after_collapse() -> void:
	if base_resource:
		panel_stylebox.bg_color = Color("999999")
