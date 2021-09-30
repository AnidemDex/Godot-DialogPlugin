tool
class_name DialogBaseNode, "res://addons/dialog_plugin/assets/Images/Plugin/bubble_icon.png"
extends Control

##
## Base class of any Dialog node.
##
## @desc:
##     Dialog nodes inheriths this class.
##     Dialog nodes are not the same as Dialog class, is just a name
##     that is used as a shorthand of DialogBaseNode node.
##     This class works as a "Dialog Node Manager".
##
## @tutorial(Online Documentation): https://anidemdex.gitbook.io/godot-dialog-plugin/documentation/node-class/class_dialog-base-node
## 

## Emmited when custom signal event is excecuted.
signal custom_signal(value)

## See [TranslationService]
const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")

## See [DialogUtil]
const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")


## The timeline to load when starting the scene
export(String, FILE) var timeline_name: String

## If [code]true[/code] call [method start_timeline] when the node is ready.
export(bool) var autostart:bool = false


## NodePath that refers to the DialogNode
export(NodePath) var DialogNode_path:NodePath

## NodePath that referes to the PortraitManager node
export(NodePath) var PortraitsNode_path:NodePath

export(NodePath) var OptionsContainer_path:NodePath

## Timeline resource used by this node. If is null, timeline_nameis loaded.
var timeline: DialogTimelineResource

## If [code]true[/code] the event have just finished.
var event_finished = false

## The [InputEvent] that will trigger the skip action of the event on finish.
var next_input = 'ui_accept'

var _used_scene:String = "res://addons/dialog_plugin/Nodes/dialogue_base_node/dialogue_base_node.tscn"

onready var DialogNode:DialogDialogueManager = get_node_or_null(DialogNode_path) as DialogDialogueManager
onready var PortraitManager := get_node_or_null(PortraitsNode_path)
onready var OptionsContainer:Container = get_node_or_null(OptionsContainer_path) as Container

func _enter_tree() -> void:
	if get_child_count() == 0 and get_tree().edited_scene_root != self:
		call_deferred("_replace")
		queue_free()


func _replace() -> void:
	var default_scene:PackedScene = load(_used_scene) as PackedScene
	var default_node:Node = default_scene.instance()
	default_node.set_deferred("filename", _used_scene)
	replace_by(default_node)


func _ready() -> void:
	if not Engine.editor_hint:
		# FIXME: You should handle this warning elsewhere
		if not((get_parent() is CanvasLayer) or (get_parent() is Control)):
			push_warning("[Dialogic] "+tr(DialogUtil.Error.DIALOGNODE_IS_NOT_CHILD_OF_CANVASLAYER))
	
		call_deferred("_set_nodes_default_values")
		if autostart:
			call_deferred("start_timeline")


func _input(event: InputEvent) -> void:
	if not next_input:
		return
	
	if event.is_action_pressed(next_input):
		if event_finished:
			timeline.go_to_next_event(self)


## Starts the timeline.
func start_timeline() -> void:
	if Engine.editor_hint:
		return
	_verify_timeline()
	timeline.start(self)


## Loads the timeline defined in timeline_name.
func load_timeline() -> DialogTimelineResource:
	if not timeline_name:
		return null
	
	var _timeline:DialogTimelineResource = ResourceLoader.load(timeline_name) as DialogTimelineResource
	return _timeline


func _verify_timeline() -> void:
	if not timeline:
		timeline = load_timeline()
		if not timeline:
			timeline = DialogUtil.Error.not_found_timeline()
			start_timeline()


func _set_nodes_default_values() -> void:
	if Engine.editor_hint:
		return
	visible = false
	if DialogNode:
		DialogNode.visible = false
		if DialogNode.NameNode:
			DialogNode.NameNode.visible = false
	if PortraitManager:
		PortraitManager.visible = false


func _get_configuration_warning() -> String:
	# FIXME: WHAT KIND OF ABOMINATION IS THIS IF STATEMENT?!
	if (get_parent() is CanvasLayer) or (get_parent() is Control):
		return ""
	return TranslationService.translate(DialogUtil.Error.DIALOGNODE_IS_NOT_CHILD_OF_CANVASLAYER, TranslationService.get_editor_locale())


func _on_event_start(_event):
	event_finished = false
	if DialogNode:
		DialogNode.event_finished = event_finished


func _on_event_finished(_event, go_to_next_event=false):
	event_finished = true
	if DialogNode:
		DialogNode.event_finished = event_finished
	
	if go_to_next_event:
		timeline.go_to_next_event(self)
