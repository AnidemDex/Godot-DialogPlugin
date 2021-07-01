tool
extends DialogEditorEventNode

# - - - - - - - - - - 
# Base class for all event editor nodes.
# - - - - - - - - - - 
# You can read more about this class in the Documentation
# https://anidemdex.gitbook.io/godot-dialog-plugin/documentation/node-class/class_dialog-editor-event-node

# - - -
# HINT
# - - -
# * Use _save_resource() method everywhere you modify the base_resource 
# properties.

# * Call _update_node_values() to refresh the node view. Is a good idea
# call _update_node_values after _save_resource().

#base_resource: res://addons/dialog_plugin/Resources/Events/LogicEvent/QuestionEvent/QuestionEvent.gd

var option_editor_scene:PackedScene = load("res://addons/dialog_plugin/Nodes/editor_event_nodes/question_event_node/option_editor/option_editor.tscn") as PackedScene

func _ready() -> void:
	# ALWAYS verify if you had a base_resource, EVERYWHERE if possible.
	if base_resource:
		# You can prepare your nodes here before updating its values
		_update_node_values()


func _update_node_values() -> void:
	var options:Dictionary = base_resource.options
	for option in options.keys():
		add_option(option)


func add_option(option:String) -> void:
	print("Option {0} added".format([option]))

