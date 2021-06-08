tool
extends DialogEditorEventNode

## Use _save_resource() method everywhere you update the base_resource
## properties. Then, call again _update_node_values if you want

#base_resource = "res://addons/dialog_plugin/Resources/Events/SetEvent/SetEvent.gd"

export(NodePath) var VariableName_path:NodePath
export(NodePath) var VariableValue_path:NodePath

var _variable_resource = load("res://addons/dialog_plugin/Database/SavedVariables.tres")

onready var variable_name_node:LineEdit = get_node(VariableName_path) as LineEdit
onready var variable_value_node:LineEdit = get_node(VariableValue_path) as LineEdit


func _ready() -> void:
	# ALWAYS verify if you had a base_resource
	if base_resource:
		# You can prepare your nodes here before updating its values
		_update_node_values()


func _update_node_values() -> void:
	variable_name_node.text = base_resource.variable_name
	variable_value_node.text = str(base_resource.variable_value)


func _on_VariableName_text_changed(new_text: String) -> void:
	base_resource.variable_name = new_text
	_save_resource()


func _on_VariableValue_text_changed(new_text: String) -> void:
	base_resource.variable_value = new_text
	_save_resource()
