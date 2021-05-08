#tool
extends EditorInspectorPlugin

var BaseMetaEditorScene = load("res://addons/dialog_plugin/Other/translation_service/editor_node/base_meta_editor.tscn")
var TextMetaEditorScene = load("res://addons/dialog_plugin/Other/translation_service/editor_node/text_node/text_meta_editor.tscn")

var modified_object = null
var _control = null

func parse_begin(object: Object) -> void:
	if object is Control:
		modified_object = object


func can_handle(object: Object) -> bool:
	if object is Control:
		return true
	return false


func parse_end() -> void:
	if modified_object:
		if _control and is_instance_valid(_control):
			print("Control existed before calling parse end")
			_control.free()
			_control = null

		if "text" in modified_object:
			_control = TextMetaEditorScene.instance()
			pass
		else:
			_control = BaseMetaEditorScene.instance()
			pass
		_control.BaseNode = modified_object
		add_custom_control(_control)


func _notification(what:int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if modified_object:
			modified_object = null
		if _control and is_instance_valid(_control):
			_control.free()
			_control = null

