tool
extends Control

const DialogDB = preload("res://addons/dialog_plugin/Core/DialogDatabase.gd")

export(PackedScene) var editor_view_scene

var _editor_node:Control

func _ready() -> void:
	scan_resources()
	instance_editor_scene()


func _draw() -> void:
	if visible:
		instance_editor_scene()

func scan_resources() -> void:
	DialogDB.EditorTranslations.get_database().scan_resources_folder()
	DialogDB.Timelines.get_database().scan_resources_folder()
	DialogDB.Characters.get_database().scan_resources_folder()

func instance_editor_scene() -> void:
	if not _editor_node:
		_editor_node = editor_view_scene.instance()
		call_deferred("add_child", _editor_node)
