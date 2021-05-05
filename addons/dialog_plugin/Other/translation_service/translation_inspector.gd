tool
extends EditorInspectorPlugin

const BaseMetaEditorScene = preload("res://addons/dialog_plugin/Other/translation_service/editor_node/base_meta_editor.tscn")
const TextMetaEditorScene = preload("res://addons/dialog_plugin/Other/translation_service/editor_node/text_node/text_meta_editor.tscn")

var modified_object = null

func parse_begin(object: Object) -> void:
	if object is Control:
		modified_object = object

func can_handle(object: Object) -> bool:
	if object is Control:
		return true
	return false

func parse_end() -> void:
	if modified_object:
		var _control
		if "text" in modified_object:
			_control = TextMetaEditorScene.instance()
		else:
			_control = BaseMetaEditorScene.instance()
		_control.BaseNode = modified_object
		add_custom_control(_control)

