tool
class_name DialogEventResource
extends Resource

const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")

signal event_started(event_resource)
signal event_finished(event_resource)

export(bool) var skip:bool = false

var _caller:DialogBaseNode = null
var event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/event_node_template.tscn"

#warning-ignore-all:unused_argument
func excecute(caller:DialogBaseNode) -> void:
	emit_signal("event_started", self)


func finish(jump_to_next_event=skip) -> void:
	emit_signal("event_finished", self, jump_to_next_event)


func get_event_editor_node() -> DialogEditorEventNode:
	var _scene_resource:PackedScene = load(event_editor_scene_path)
	_scene_resource.resource_local_to_scene = true
	var _instance = _scene_resource.instance() as DialogEditorEventNode
	_instance.base_resource = self
	return _instance
