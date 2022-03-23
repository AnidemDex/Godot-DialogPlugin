tool
extends Control

export(NodePath) var VersionNodePath:NodePath

var repository:String = ""
var docs:String = ""
var version:String = "0"

onready var version_node:Label = get_node(VersionNodePath) as Label

func _ready() -> void:
	version_node.text = version


func _on_Docs_pressed() -> void:
	OS.shell_open(docs)


func _on_Repository_pressed() -> void:
	OS.shell_open(repository)


func _on_License_pressed() -> void:
	var license_path = ProjectSettings.globalize_path("res://addons/event_system_plugin/LICENSE")
	OS.shell_open(license_path)
