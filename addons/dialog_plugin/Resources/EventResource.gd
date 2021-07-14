tool
class_name DialogEventResource
extends Resource

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")
const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")
const VARIABLES_PATH = preload("res://addons/dialog_plugin/Core/DialogResources.gd").DEFAULT_VARIABLES_PATH

signal event_started(event_resource)
signal event_finished(event_resource, jump_to_next_event)

export(bool) var skip:bool = false

var _caller:DialogBaseNode = null
var event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/event_node_template.tscn"

func get_class(): return "EventResource"

func _execute(caller:DialogBaseNode) -> void:
	_caller = caller
	emit_signal("event_started", self)
	execute(caller)


func execute(caller:DialogBaseNode) -> void:
	DialogUtil.Logger.print_info(self, "execute method was not overrided")


func finish(jump_to_next_event=skip) -> void:
	emit_signal("event_finished", self, jump_to_next_event)


# Returns DialogEditorEventNode to be used inside the editor.
func get_event_editor_node() -> DialogEditorEventNode:
	var _scene_resource:PackedScene = load(event_editor_scene_path)
	_scene_resource.resource_local_to_scene = true
	var _instance := _scene_resource.instance() as DialogEditorEventNode
	_instance.base_resource = self
	return _instance
