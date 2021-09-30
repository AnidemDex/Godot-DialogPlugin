tool
class_name DialogBoxNode
extends DialogBaseNode

# This does nothing special. It's just a placeholder.

# Consider inherith DialogicBaseNode and replacing its script
# if you want to use a custom DialogNode, or inherith this scene
# and replace this script.

# DO NOT MODIFY THIS FILE. OTHER RESOURCES THAT DEPENDS ON IT MAY BE AFFECTED

func _init() -> void:
	_used_scene = "res://addons/dialog_plugin/Nodes/ingame_dialogue_box/dialog_box.tscn"
