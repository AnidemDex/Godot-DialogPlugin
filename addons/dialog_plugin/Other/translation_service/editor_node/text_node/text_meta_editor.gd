tool
extends "res://addons/dialog_plugin/Other/translation_service/editor_node/base_meta_editor.gd"

func _ready() -> void:
	if visible:
		var meta = BaseNode.get_meta_list()
		if "TEXT_KEY" in meta:
			$Category/Editors/Text_LineEdit.text = BaseNode.get_meta("TEXT_KEY")
	pass


func _on_Text_LineEdit_text_changed(new_text: String) -> void:
	if not new_text:
		BaseNode.set_meta("TEXT_KEY", null)
	else:
		BaseNode.set_meta("TEXT_KEY", new_text)
