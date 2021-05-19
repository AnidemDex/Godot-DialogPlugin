tool
extends PanelContainer

signal variable_removed

export(NodePath) var VarNameLabel_path:NodePath
export(NodePath) var VarDisplayer_path:NodePath
export(NodePath) var VarIcon_path:NodePath

var variable_name:String = ""
var variable_type:int = TYPE_NIL

var DialogResources := load("res://addons/dialog_plugin/Core/DialogResources.gd")
var _variables_resource:Resource = load(DialogResources.DEFAULT_VARIABLES_PATH)

onready var name_label_node:Label = get_node(VarNameLabel_path) as Label
onready var var_displayer = get_node(VarDisplayer_path)
onready var type_icon_node:TextureRect = get_node(VarIcon_path) as TextureRect

func _ready() -> void:
	if not variable_name:
		return
	
	_update_node_values()


func _update_node_values():
	var _variables:Dictionary = _variables_resource.variables
	var _variable_value = _reformat_value(_variables[variable_name])
	variable_type = typeof(_variable_value)
	
	name_label_node.text = variable_name
	type_icon_node.texture = get_icon("Variant", "EditorIcons")
	var_displayer.generate_displayer(_variable_value)
	


func _reformat_value(value):
	var _formated_values = {
		TYPE_BOOL: false,
		TYPE_INT: 0,
		TYPE_REAL: float(0),
		TYPE_STRING: ""
	}
	
	if typeof(value) == TYPE_STRING and value.begins_with("CHANGE_TYPE_TO:"):
		value = value.replace("CHANGE_TYPE_TO:","")
		var new_type = int(value)
		value = _formated_values.get(new_type, null)
	
	return value


func _on_var_value_modified(new_value) -> void:
	var _variables:Dictionary = _variables_resource.get_original_variables()
	var _old = _variables[variable_name]
	_variables[variable_name] = new_value


func _on_RemoveButton_pressed() -> void:
	var _variables:Dictionary = _variables_resource.get_original_variables()
	_variables.erase(variable_name)
	emit_signal("variable_removed")
