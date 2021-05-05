tool
class_name DialogEventResource
extends Resource

const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")

signal event_started(event_resource)
signal event_finished(event_resource)

var _caller:DialogBaseNode = null

#warning-ignore-all:unused_argument
func excecute(caller:DialogBaseNode) -> void:
	emit_signal("event_started", self)


func finish(skip=false) -> void:
	emit_signal("event_finished", self, skip)


func get_event_editor_node() -> DialogEditorEventNode:
	return DialogEditorEventNode.new()
