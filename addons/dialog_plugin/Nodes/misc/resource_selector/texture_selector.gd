tool
extends "res://addons/dialog_plugin/Nodes/misc/resource_selector/resource_selector.gd"

func _init() -> void:
	filters = PoolStringArray(["*.png;PNG", "*.jpg;JPG"])


func _on_FileEditor_file_selected(file_path:String) -> void:
	if load(file_path) is Texture:
		._on_FileEditor_file_selected(file_path)
		icon = load(file_path)
