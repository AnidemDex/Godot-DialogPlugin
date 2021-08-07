tool
extends PanelContainer

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")

export(NodePath) var PreviewLabel_path:NodePath
export(NodePath) var Index_path:NodePath

var base_resource:DialogEventResource
var event_index:int = -1

onready var preview_label:Label = get_node(PreviewLabel_path) as Label
onready var index_label:Label = get_node(Index_path) as Label

onready var panel_stylebox:StyleBoxFlat = get_stylebox("panel")

func update_node_values() -> void:
	var preview_string:String = base_resource.event_preview_string if base_resource else ""
	preview_string = preview_string.format(DialogUtil.get_property_values_from(base_resource))
	preview_label.text = preview_string
	index_label.text = str(event_index)

func _after_expand() -> void:
	if base_resource:
		panel_stylebox.bg_color = base_resource.event_color
	preview_label.hide()

func _after_collapse() -> void:
	if base_resource:
		panel_stylebox.bg_color = Color("999999")
	preview_label.show()
