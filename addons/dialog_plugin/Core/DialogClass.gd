class_name Dialog

##
## Static class to deal with Dialog plugin.
##
## @desc:
##     Dialog is the core class of the plugin. You can call any of its methods in any script.
##     This class exposes methods to create new Dialog nodes or modify the plugin saved variables.
##
## @tutorial(Online Documentation): https://anidemdex.gitbook.io/godot-dialog-plugin/documentation/node-class/class_dialog
##


# Hello, traveler
#
# This is an exposed class to use the plugin.
# You probably want to use those methods in runtime, this class
# was meant to be easy to use.

##########
# DOCS
##########
# Read the documentation here:
# "https://anidemdex.gitbook.io/godot-dialog-plugin/documentation/node-class/class_dialog"


const _DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")
const _VarResourcePath = _DialogResources.DEFAULT_VARIABLES_PATH
const _VarResource = preload(_VarResourcePath)

## Default TextBox Scene path
const DefaultDialogTextBox:String = "res://addons/dialog_plugin/Nodes/ingame_dialogue_box/ingame_dialogue_node.tscn"

## Default Bubble Scene path
const DefaultDialogBubble:String = "res://addons/dialog_plugin/Nodes/ingame_dialogue_bubble/dialog_bubble.tscn"


const _DialogDB = preload("res://addons/dialog_plugin/Core/DialogDatabase.gd")

## Returns a DialogBaseNode instance.
static func get_new_dialog_node(timeline="", dialog_scene_path:String="", use_bubble:bool=false) -> DialogBaseNode:
	var _dialog_node = null
	if dialog_scene_path:
		var _dialog_scene:PackedScene = load(dialog_scene_path) as PackedScene
		_dialog_node = _dialog_scene.instance()
		
		if not(_dialog_node is DialogBaseNode):
			if _dialog_node is Node:
				_dialog_node.free()
			_dialog_node = null
	
	if not _dialog_node:
		_dialog_node = get_default_dialog_textbox() if not use_bubble else get_default_dialog_bubble()
	
	
	if timeline is String:
		(_dialog_node as DialogBaseNode).timeline_name = timeline
	elif timeline is DialogTimelineResource:
		(_dialog_node as DialogBaseNode).timeline = timeline
	return _dialog_node


## Returns a DialogBaseNode instance of the default textbox.
static func get_default_dialog_textbox() -> DialogBaseNode:
	var _dialog_textbox_scene:PackedScene = load(DefaultDialogTextBox) as PackedScene
	var _dialog_textbox_node:DialogBaseNode = _dialog_textbox_scene.instance() as DialogBaseNode
	return _dialog_textbox_node


## Returns a DialogBaseNode instance of the default dialog bubble.
static func get_default_dialog_bubble() -> DialogBaseNode:
	var _dialog_bubble_scene:PackedScene = load(DefaultDialogBubble) as PackedScene
	var _dialog_bubble_node:DialogBaseNode = _dialog_bubble_scene.instance() as DialogBaseNode
	return _dialog_bubble_node


## Returns a copy of the saved plugin variables.
static func get_variables() -> Dictionary:
	return _VarResource.variables


## Returns the variable value of the given key.
## If the variable doesn't exist, returns null and a warning is printed in the console.
static func get_variable(key:String):
	var _variables = get_variables()
	var _value = _variables.get(key, null)
	return _value


## Sets the value in the given key. If they key doesn't exist, a new one is created.
static func set_variable(key:String, value) -> void:
	_VarResource.set_value(key,value)
