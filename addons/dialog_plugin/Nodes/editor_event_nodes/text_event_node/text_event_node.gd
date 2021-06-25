tool
extends DialogEditorEventNode

const CustomTextEdit = preload("res://addons/dialog_plugin/Nodes/editor_event_nodes/custom_text_edit_node/text_edit_container.gd")
const CharacterListButton = preload("res://addons/dialog_plugin/Nodes/misc/character_list_button/character_list_button.gd")

export(NodePath) var PreviewText_path:NodePath
export(NodePath) var TextEdit_path:NodePath
export(NodePath) var CharacterBtn_path:NodePath
export(NodePath) var TranslationKeyLabel_path:NodePath

var timeline_resource = null setget _set_timeline

onready var preview_text_node:Label = get_node(PreviewText_path) as Label
onready var text_edit_node:CustomTextEdit = get_node_or_null(TextEdit_path) as CustomTextEdit
onready var character_button_node:CharacterListButton = get_node_or_null(CharacterBtn_path) as CharacterListButton
onready var translation_key_label_node:LineEdit = get_node_or_null(TranslationKeyLabel_path) as LineEdit


func _ready() -> void:
	if base_resource:
		emit_signal("timeline_requested", self)


func _update_node_values() -> void:
	update_node_translation_key()
	update_node_character()
	update_node_text()


func update_node_text() -> void:
	base_resource = base_resource as DialogTextEvent
	
	var _text:String = base_resource.text
	var _transaltion_key:String = base_resource.translation_key
	
	preview_text_node.text = _text
	text_edit_node.set_text(_text)


func update_node_character() -> void:
	base_resource = base_resource as DialogTextEvent
	
	var _character:DialogCharacterResource = base_resource.character
	
	character_button_node.select_item_by_resource(_character)


func update_node_translation_key() -> void:
	base_resource = base_resource as DialogTextEvent
	
	var translation_key:String = base_resource.translation_key
	
	if translation_key == "__SAME_AS_TEXT__":
		translation_key = ""
	
	translation_key_label_node.text = translation_key


func after_collapse_properties() -> void:
	update_node_text()
	preview_text_node.visible = true


func after_expand_properties() -> void:
	preview_text_node.visible = false


func _set_timeline(value:DialogTimelineResource) -> void:
	timeline_resource = value
	character_button_node.characters = timeline_resource._related_characters
	_update_node_values()


func _on_CharacterList_item_selected(index: int) -> void:
	var _char_metadata = character_button_node.get_selected_metadata()
	var _new_character:DialogCharacterResource = null
	
	if _char_metadata is Dictionary:
		_new_character = _char_metadata.get("character", null)
	
	base_resource.set("character", _new_character)
	
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


func _on_CustomTextEdit_text_changed(new_text:String) -> void:
	base_resource.set("text", new_text)
