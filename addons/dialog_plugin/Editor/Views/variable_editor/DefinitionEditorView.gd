tool
extends VBoxContainer

export(NodePath) var NewItemPopup_path:NodePath
export(NodePath) var VarListContainer_path:NodePath

var DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")

var variable_node_scene:PackedScene = load("res://addons/dialog_plugin/Editor/Views/variable_editor/variable_node/variable_node.tscn")

onready var var_list_nodes_container:Control = get_node(VarListContainer_path) as Control
onready var new_item_popup_node:ConfirmationDialog = get_node(NewItemPopup_path) as ConfirmationDialog

func _ready() -> void:
	if get_tree().edited_scene_root == self:
		return
	
	_load_events()

func _unload_events() -> void:
	for child in var_list_nodes_container.get_children():
		child.queue_free()


func _load_events() -> void:
	_unload_events()
	
	var _variables:Dictionary = load(DialogResources.DEFAULT_VARIABLES_PATH).variables
	
	for variable in _variables.keys():
		var _var_node = variable_node_scene.instance()
		_var_node.variable_name = variable
		_var_node.connect("variable_removed", self, "_on_VarNode_variable_removed")
		var_list_nodes_container.add_child(_var_node)


func _on_Add_pressed() -> void:
	new_item_popup_node.popup_centered()


func _on_NewItemPopup_confirmed() -> void:
	var var_resource = load(DialogResources.DEFAULT_VARIABLES_PATH)
	var variable_key = new_item_popup_node.text_node.text
	var type = new_item_popup_node.selected_type
	var _variables:Dictionary = var_resource.get_original_variables()
	_variables[variable_key] = "CHANGE_TYPE_TO:{type}".format({"type":type})
	
	_load_events()


func _on_Save_pressed() -> void:
	var _resource = load(DialogResources.DEFAULT_VARIABLES_PATH)
	var _err = ResourceSaver.save(_resource.resource_path, _resource)
	_load_events()

func _on_VarNode_variable_removed() -> void:
	_load_events()
