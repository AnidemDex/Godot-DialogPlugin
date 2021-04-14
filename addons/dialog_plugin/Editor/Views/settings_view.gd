tool
extends MarginContainer

const DialogDB = preload("res://addons/dialog_plugin/Core/DialogDatabase.gd")

export(NodePath) var DisplayEditorDebug_path

var _db

onready var display_editor_debug_node = get_node_or_null(DisplayEditorDebug_path)

func _ready() -> void:
	load_configuration()

func _draw() -> void:
	if visible:
		load_configuration()

func load_configuration() -> void:
	_db = DialogDB.get_editor_configuration()
	
	display_editor_debug_node.pressed = _db.editor_debug_mode


func _on_DisplayEditorDebugButton_pressed(button_pressed: bool) -> void:
	_db.editor_debug_mode = button_pressed
	ResourceSaver.save(_db.resource_path, _db)


func _on_ScanFoldersButton_pressed() -> void:
	DialogDB.Timelines.get_database().scan_timelines_folder()
	DialogDB.Characters.get_database().scan_characters_folder()


func _on_DropDatabaseButton_pressed() -> void:
	DialogDB.Timelines.get_database().resources = null
	DialogDB.Characters.get_database().resources = null
