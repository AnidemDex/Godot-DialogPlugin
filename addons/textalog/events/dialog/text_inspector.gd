extends EditorInspectorPlugin

var ObjClass = load("res://addons/textalog/events/dialog/text.gd")

func can_handle(object: Object) -> bool:
	return object is ObjClass
