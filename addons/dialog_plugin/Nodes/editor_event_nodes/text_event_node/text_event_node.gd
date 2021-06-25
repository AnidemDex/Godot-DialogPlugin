tool
extends DialogEditorEventNode

export(NodePath) var TextEdit_path:NodePath
export(NodePath) var CharacterBtn_path:NodePath
export(NodePath) var TranslationKeyLabel_path:NodePath

var timeline_resource = null setget _set_timeline

onready var text_edit_node = get_node_or_null(TextEdit_path)
onready var character_button_node = get_node_or_null(CharacterBtn_path)
onready var translation_key_label_node = get_node_or_null(TranslationKeyLabel_path)

func _ready() -> void:
	emit_signal("timeline_requested", self)


func _update_node_values() -> void:
	return
	var _text = base_resource.text
	if base_resource.translation_key != "__SAME_AS_TEXT__":
		_text = TranslationService.translate(base_resource.translation_key)
		if _text == base_resource.translation_key:
			_text = ""
	text_edit_node.text = _text
	
	if base_resource.character:
		character_button_node.select_item_by_resource(base_resource.character)
	else:
		character_button_node.select(0)
	
	if not base_resource.translation_key or base_resource.translation_key == base_resource.SAME_AS_TEXT:
		translation_key_label_node.text = ""
	else:
		translation_key_label_node.text = base_resource.translation_key
	
	index_label_node.text = str(idx)


func _save_resource() -> void:
	emit_signal("save_item_requested", base_resource)


func _set_timeline(value:DialogTimelineResource) -> void:
	timeline_resource = value
	character_button_node.characters = timeline_resource._related_characters
	_update_node_values()


func _on_resource_change() -> void:
	_update_node_values()


func _on_TextEdit_text_changed() -> void:
	if text_edit_node.text != base_resource.text:
		(base_resource as DialogTextEvent).text = text_edit_node.text


func _on_TextEdit_focus_exited() -> void:
	DialogUtil.Logger.print(self,"Focus lost, saving things")
	_save_resource()


func _on_CharacterList_item_selected(index: int) -> void:
	var _char_metadata = character_button_node.get_selected_metadata()
	if _char_metadata is Dictionary:
		base_resource.character = (_char_metadata as Dictionary).get("character", null)
	else:
		base_resource.character = null
	_save_resource()


func _on_TranslationKey_text_changed(new_text: String) -> void:
	var _translation_key = new_text
	if not _translation_key:
		_translation_key = "__SAME_AS_TEXT__"
	
	if _translation_key != base_resource.translation_key:
		base_resource.translation_key = _translation_key


func _on_TranslationKey_focus_exited() -> void:
	_save_resource()


func _on_CharacterList_character_added() -> void:
	_save_resource()
	_update_node_values()
