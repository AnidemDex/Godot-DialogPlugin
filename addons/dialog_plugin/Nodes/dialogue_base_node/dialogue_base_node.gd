tool
class_name DialogBaseNode, "res://addons/dialog_plugin/assets/Images/Plugin/bubble_icon.png"
extends CanvasItem

signal custom_signal(value)

const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")

## The timeline to load when starting the scene
export(String, FILE) var timeline_name: String

export(NodePath) var DialogNode_path:NodePath
export(NodePath) var PortraitsNode_path:NodePath
export(NodePath) var OptionsContainer_path:NodePath

var timeline: DialogTimelineResource
var event_finished = false
var next_input = 'ui_accept'

onready var DialogNode:DialogDialogueManager = get_node_or_null(DialogNode_path) as DialogDialogueManager
onready var PortraitManager := get_node_or_null(PortraitsNode_path)
onready var OptionsContainer:Container = get_node_or_null(OptionsContainer_path) as Container

func _ready() -> void:
	if not Engine.editor_hint:
		# FIXME: You should handle this warning elsewhere
		if not((get_parent() is CanvasLayer) or (get_parent() is Control)):
			push_warning("[Dialogic] "+tr(DialogUtil.Error.DIALOGNODE_IS_NOT_CHILD_OF_CANVASLAYER))


func _input(event: InputEvent) -> void:
	if not next_input:
		return
	
	if event.is_action_pressed(next_input):
		if event_finished:
			timeline.go_to_next_event(self)


func start_timeline() -> void:
	if Engine.editor_hint:
		return
	_verify_timeline()
	timeline.start(self)


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
