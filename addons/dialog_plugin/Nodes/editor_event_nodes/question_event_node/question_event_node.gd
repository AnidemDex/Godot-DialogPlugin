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

#base_resource: "res://addons/dialog_plugin/Resources/Events/LogicEvent/QuestionEvent/QuestionEvent.gd"

const OptionEditor = preload("res://addons/dialog_plugin/Nodes/editor_event_nodes/question_event_node/option_editor/option_editor.gd")

export(NodePath) var OptionsContainer_path:NodePath

var option_editor_scene:PackedScene = load("res://addons/dialog_plugin/Nodes/editor_event_nodes/question_event_node/option_editor/option_editor.tscn") as PackedScene

onready var options_container_node:Container = get_node(OptionsContainer_path) as Container

func _ready() -> void:
	# ALWAYS verify if you had a base_resource, EVERYWHERE if possible.
	if base_resource:
		# You can prepare your nodes here before updating its values
		_update_node_values()


func _update_node_values() -> void:
	var options:Dictionary = base_resource.options
	for child in options_container_node.get_children():
		child.queue_free()
	for option in options.keys():
		print("Adding option: ", option)
		add_option(option)


func add_option(option:String) -> void:
	var option_node:OptionEditor = option_editor_scene.instance() as OptionEditor
	option_node.connect("save", self, "_on_OptionEditor_save")
	option_node.connect("option_changed", self, "_on_OptionEditor_option_changed")
	options_container_node.add_child(option_node)
	option_node.option = option
	option_node.timeline = base_resource.options.get(option, DialogTimelineResource.new())


func _unfocused():
	if get_focus_owner() is DialogEditorEventNode:
		._unfocused()


func can_drop_data(position: Vector2, data) -> bool:
	if data is DialogEventResource:
		expand_properties()
		
	return false


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_MOUSE_EXIT:
			var _mouse_still_inside_node:bool = get_global_rect().has_point(get_global_mouse_position())
			if get_viewport().gui_is_dragging() and not _mouse_still_inside_node:
				collapse_properties()


func _on_AddOption_pressed() -> void:
	add_option("")


func _on_OptionEditor_option_changed(old_option, new_option) -> void:
	var options:Dictionary = base_resource.options
	if new_option != "":
		options[new_option] = options.get(old_option, DialogTimelineResource.new())
	options.erase(old_option)
	_save_resource()
	_update_node_values()


func _on_OptionEditor_save() -> void:
	_save_resource()
