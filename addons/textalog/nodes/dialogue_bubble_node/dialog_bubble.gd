tool
extends DialogNode
class_name DialogBubble

func _init() -> void:
	._init()
	_used_scene = "res://addons/textalog/nodes/dialogue_bubble_node/dialog_bubble.tscn"

static func instance() -> Node:
	var _default_scene := load("res://addons/textalog/nodes/dialogue_bubble_node/dialog_bubble.tscn") as PackedScene
	return _default_scene.instance()
