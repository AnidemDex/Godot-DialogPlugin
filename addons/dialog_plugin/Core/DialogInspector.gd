tool
extends EditorInspectorPlugin

const TimelinePickerScript = preload("res://addons/dialog_plugin/Nodes/editor_dialog_inspector/dialog_timeline_inspector.gd")

func can_handle(object: Object) -> bool:
	if object is DialogBaseNode:
		return true
	return false


func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	if path == "timeline_name":
		add_property_editor(path, TimelinePickerScript.new())
		return true
	return false
