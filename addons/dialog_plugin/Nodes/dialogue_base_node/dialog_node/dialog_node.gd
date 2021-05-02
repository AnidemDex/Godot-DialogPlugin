tool
class_name DialogDialogueNode
extends Control

export(NodePath) var TextNode_path:NodePath
export(NodePath) var NameNode_path:NodePath
export(NodePath) var NextIndicator_path:NodePath
export(float) var text_speed:float = 0.02

var event_finished = false

onready var TextNode:RichTextLabel = (get_node_or_null(TextNode_path) as RichTextLabel)
onready var NameNode:Label = (get_node_or_null(NameNode_path) as Label)
onready var NextIndicatorNode := get_node_or_null(NextIndicator_path)

func _process(delta: float) -> void:
	if not NextIndicatorNode:
		return
	if Engine.editor_hint:
		return
	NextIndicatorNode.visible = event_finished
