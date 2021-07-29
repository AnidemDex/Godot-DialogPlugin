tool
extends PanelContainer

export(NodePath) var PreviewLabel_path:NodePath
export(NodePath) var Index_path:NodePath

var base_resource:DialogEventResource
var event_index:int = -1

onready var preview_label:Label = get_node(PreviewLabel_path) as Label
onready var index_label:Label = get_node(Index_path) as Label

func update_node_values() -> void:
	print_debug("Updating preview")
	preview_label.text = base_resource.event_preview_string if base_resource else ""
	index_label.text = str(event_index)
