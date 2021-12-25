tool
extends Control
class_name DialogNode

## Emmited when the text was fully displayed
signal text_displayed

## Emmited when a portrait was added
signal portrait_added(character, portrait)
## Emmited when a portrait that is already in the scene, changes
signal portrait_changed(character, portrait)
## Emmited when a portrait is removed from scene
signal portrait_removed(character)

## Emmited when an option is added
signal option_added(option_button)
## Emmited when an option is selected
signal option_selected(option_string)

## Path to [Class DialogManager] node
export(NodePath) var DialogNode_Path:NodePath
## Path to [Class PortraitManager] node
export(NodePath) var PortraitNode_Path:NodePath
## Path to [Class OptionsManager] node
export(NodePath) var OptionsNode_Path:NodePath
## Path to name node
export(NodePath) var NameNode_path:NodePath

var dialog_manager:DialogManager
var portrait_manager:PortraitManager
var options_manager:OptionsManager
var name_node:Label

var _used_scene = "res://addons/textalog/nodes/dialogue_base_node/dialogue_base_node.tscn"

## Shows a text inmediatly in screen
func show_text(text:String, with_text_speed:float=0):
	if not is_instance_valid(dialog_manager):
		return
	
	show()
	dialog_manager.set_text(text)
	dialog_manager.display_text()


## Adds a selectable option on screen
func add_option(option:String) -> void:
	if not is_instance_valid(options_manager):
		return
	
	options_manager.add_option(option)


## Make an instance of this class. Required since you can't call .new() directly
static func instance() -> Node:
	var _default_scene := load("res://addons/textalog/nodes/dialogue_base_node/dialogue_base_node.tscn") as PackedScene
	return _default_scene.instance()


##########
# Private things
##########

func _fake_ready() -> void:
	_set_default_nodes()
	_connect_dialog_manager_signals()
	_connect_portrait_manager_signals()
	_connect_options_manager_signals()
	
	if is_instance_valid(name_node):
		name_node.add_stylebox_override("normal", get_stylebox("name", "DialogNode"))
	
	if not Engine.editor_hint:
		hide()


func _fake_enter_tree() -> void:
	if get_tree().edited_scene_root == self:
		# Warn about instancing class as root of scene
		return
	
	if _used_scene == "":
		# No used scene, then no replace
		return
	
	if _have_no_childs():
		call_deferred("_replace")
		queue_free()


func _update_all_childs():
	for child in get_children():
		child.update()


func _set_default_nodes():
	# This has to be done manually since POST_ENTER_TREE is too early
	# and NOTIFICATION_READY is too late to get an onready variable
	
	dialog_manager =  get_node_or_null(DialogNode_Path) as DialogManager
	portrait_manager = get_node_or_null(PortraitNode_Path) as PortraitManager
	options_manager = get_node_or_null(OptionsNode_Path) as OptionsManager
	name_node = get_node_or_null(NameNode_path) as Label


func _connect_dialog_manager_signals():
	if not is_instance_valid(dialog_manager):
		return
	
	if not dialog_manager.is_connected("text_displayed", self, "emit_signal"):
		dialog_manager.connect("text_displayed", self, "emit_signal", ["text_displayed"])


func _connect_portrait_manager_signals():
	if not is_instance_valid(portrait_manager):
		return
	
	
	if not portrait_manager.is_connected("portrait_added", self, "__on_PortraitManager_portrait_added"):
		portrait_manager.connect("portrait_added", self, "__on_PortraitManager_portrait_added")
	if not portrait_manager.is_connected("portrait_changed", self, "__on_PortraitManager_portrait_changed"):
		portrait_manager.connect("portrait_changed", self, "__on_PortraitManager_portrait_changed")
	if not portrait_manager.is_connected("portrait_removed", self, "__on_PortraitManager_portrait_removed"):
		portrait_manager.connect("portrait_removed", self, "__on_PortraitManager_portrait_removed")


func _connect_options_manager_signals() -> void:
	if not is_instance_valid(options_manager):
		return
	
	if not options_manager.is_connected("option_added", self, "__on_OptionManager_option_added"):
		options_manager.connect("option_added", self, "__on_OptionManager_option_added")
	if not options_manager.is_connected("option_selected", self, "__on_OptionManager_option_selected"):
		options_manager.connect("option_selected", self, "__on_OptionManager_option_selected")

func _have_no_childs() -> bool:
	return get_child_count() == 0


func _replace() -> void:
	if _used_scene == "":
		# There's no used scene, you may warn the user about that.
		push_warning("Tried to replace DialogNode but no scene was provided.")
		return
	
	var default_scene:PackedScene = load(_used_scene) as PackedScene
	var default_node:Node = default_scene.instance()
	default_node.set_deferred("filename", _used_scene)
	replace_by(default_node)


func _get_configuration_warning() -> String:
	var _error_string := ""
	
	if visible:
		_error_string += "- Dialog node will hide by default unless you call show() or set visible to true.\nMaking them visible for editing is fine, but they will hide upon running.\n"
	
	if get_parent():
		match get_parent().get_class():
			"CanvasLayer", "Control", "Node", "Viewport":
				pass
			var _anything_else:
				_error_string += "- DIALOGNODE_IS_NOT_CHILD_OF_CANVASLAYER\n"
	
	return _error_string


func _get_minimum_size() -> Vector2:
	return Vector2(24, 24)

##########
# Signals
##########
func __on_PortraitManager_portrait_added(character, portrait) -> void:
	emit_signal("portrait_added", character, portrait)

func __on_PortraitManager_portrait_changed(character, portrait) -> void:
	emit_signal("portrait_changed", character, portrait)

func __on_PortraitManager_portrait_removed(character) -> void:
	emit_signal("portrait_removed", character)

func __on_OptionManager_option_added(option_button) -> void:
	emit_signal("option_added", option_button)

func __on_OptionManager_option_selected(option_string) -> void:
	emit_signal("option_selected", option_string)
##########


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			_fake_enter_tree()
		NOTIFICATION_POST_ENTER_TREE:
			_fake_ready()
		NOTIFICATION_VISIBILITY_CHANGED:
			update_configuration_warning()
		NOTIFICATION_THEME_CHANGED,NOTIFICATION_DRAW,NOTIFICATION_ENTER_CANVAS:
			_update_all_childs()


func _hide_script_from_inspector():
	return true
