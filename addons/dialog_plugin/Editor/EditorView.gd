tool
extends Control

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")
const DialogDB = preload("res://addons/dialog_plugin/Core/DialogDatabase.gd")
const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")

const CharacterEditorScene = preload("res://addons/dialog_plugin/Editor/Views/character_editor/CharacterEditorView.tscn")
const TimelineEditorScene = preload("res://addons/dialog_plugin/Editor/Views/timeline_editor/TimelineEditorView.tscn")

var _editor_view:Control

func _ready() -> void:
	# Be careful when using this. It could block the main thread for a few seconds
	# Need to be improved
	TranslationService.translate_node_recursively(self)


func _on_ToolBar_character_selected(character) -> void:
	if _editor_view:
		_editor_view.queue_free()
	_editor_view = CharacterEditorScene.instance()
	_editor_view.base_resource = character
	$ViewContainer.add_child(_editor_view)



func _on_ToolBar_timeline_selected(timeline) -> void:
	if _editor_view:
		_editor_view.queue_free()
	_editor_view = TimelineEditorScene.instance()
	_editor_view.base_resource = timeline
	$ViewContainer.add_child(_editor_view)

func _exit_tree() -> void:
	if _editor_view and is_instance_valid(_editor_view):
		_editor_view.free()
