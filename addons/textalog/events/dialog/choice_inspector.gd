extends EditorInspectorPlugin

const InspectorTools = preload("res://addons/textalog/core/inspector_tools.gd")

var plugin_script:EditorPlugin
var editor_inspector:EditorInspector
var editor_gui:Control

var ObjClass = load("res://addons/textalog/events/dialog/choice.gd")

func can_handle(object: Object) -> bool:
	return object is ObjClass

func parse_category(object: Object, category: String) -> void:
	if not editor_inspector.has_method("get_category_instance"):
		return


func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	return false
