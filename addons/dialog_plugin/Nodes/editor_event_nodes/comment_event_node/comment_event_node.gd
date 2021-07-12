tool
extends DialogEditorEventNode

# base_resource: "res://addons/dialog_plugin/Resources/Events/MiscelaneousEvent/Comment/CommentEvent.gd"

export(NodePath) var Comment_Path:NodePath
export(NodePath) var CommentPreview_Path:NodePath

onready var comment_node:TextEdit = get_node(Comment_Path) as TextEdit
onready var comment_preview_node:Label = get_node(CommentPreview_Path) as Label

func _ready() -> void:
	# ALWAYS verify if you had a base_resource
	if base_resource:
		# You can prepare your nodes here before updating its values
		_update_node_values()


func _update_node_values() -> void:
	comment_preview_node.text = "# {0}".format([base_resource.text])
	comment_node.text = base_resource.text


func expand_properties() -> void:
	.expand_properties()
	comment_preview_node.visible = false


func _unfocused() -> void:
	._unfocused()
	comment_preview_node.visible = true
	_update_node_values()


func _on_Comment_text_changed() -> void:
	base_resource.text = comment_node.text
	resource_value_modified()
