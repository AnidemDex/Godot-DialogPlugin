tool
extends DialogEditorEventNode

const CustomTextEdit = preload("res://addons/dialog_plugin/Nodes/editor_event_nodes/custom_text_edit_node/text_edit_container.gd")
const CharacterListButton = preload("res://addons/dialog_plugin/Nodes/misc/character_list_button/character_list_button.gd")
const CharacterSelector = preload("res://addons/dialog_plugin/Nodes/misc/character_selector/character_selector.gd")

export(NodePath) var PreviewCharacter_path:NodePath
export(NodePath) var PreviewText_path:NodePath
export(NodePath) var TextEdit_path:NodePath
export(NodePath) var CharacterBtn_path:NodePath
export(NodePath) var TranslationKeyLabel_path:NodePath
export(NodePath) var TextSpeed_path:NodePath
export(NodePath) var Continue_path:NodePath

var timeline_resource = null setget _set_timeline

onready var preview_char_node:Label = get_node(PreviewCharacter_path) as Label
onready var preview_text_node:Label = get_node(PreviewText_path) as Label
onready var text_edit_node:CustomTextEdit = get_node(TextEdit_path) as CustomTextEdit
onready var character_selector_node:CharacterSelector = get_node(CharacterBtn_path) as CharacterSelector
onready var translation_key_label_node:LineEdit = get_node(TranslationKeyLabel_path) as LineEdit
onready var text_speed_node:SpinBox = get_node(TextSpeed_path) as SpinBox
onready var continue_node:CheckBox = get_node(Continue_path) as CheckBox

func _ready() -> void:
	if base_resource:
		emit_signal("timeline_requested", self)


func _update_node_values() -> void:
	update_node_translation_key()
	update_node_character()
	update_node_text()
	update_node_text_speed()
	update_node_continue_previous_text()


func update_node_text() -> void:
	if not base_resource:
		return
	base_resource = base_resource as DialogTextEvent
	
	var _text:String = base_resource.text
	var _transaltion_key:String = base_resource.translation_key
	
	preview_text_node.text = _text
	text_edit_node.set_text(_text)


func update_node_character() -> void:
	base_resource = base_resource as DialogTextEvent
	
	var _character:DialogCharacterResource = base_resource.character
	var _character_name:String = _character.display_name if _character else ""
	
	character_selector_node.set_character(_character_name)
	preview_char_node.text = _character_name


func update_node_translation_key() -> void:
	base_resource = base_resource as DialogTextEvent
	
	var translation_key:String = base_resource.translation_key
	
	if translation_key == "__SAME_AS_TEXT__":
		translation_key = ""
	
	translation_key_label_node.text = translation_key


func update_node_text_speed() -> void:
	text_speed_node.value = base_resource.text_speed


func update_node_continue_previous_text() -> void:
	continue_node.pressed = base_resource.continue_previous_text


func after_collapse_properties() -> void:
	update_node_text()
	update_node_character()
	preview_text_node.show()
	preview_char_node.show()


func after_expand_properties() -> void:
	preview_text_node.hide()
	preview_char_node.hide()


func _set_timeline(value:DialogTimelineResource) -> void:
	if not value:
		return
	timeline_resource = value
	_update_node_values()


func _on_TranslationKey_text_entered(new_text: String) -> void:
	var _translation_key = new_text
	if not _translation_key:
		_translation_key = "__SAME_AS_TEXT__"
	
	if _translation_key != base_resource.translation_key:
		base_resource.translation_key = _translation_key
		resource_value_modified()


func _on_CustomTextEdit_text_changed(new_text:String) -> void:
	base_resource.set("text", new_text)
	resource_value_modified()


func _on_TextSpeed_value_changed(value: float) -> void:
	base_resource.set("text_speed", value)
	resource_value_modified()


func _on_ContinuePrevious_toggled(button_pressed: bool) -> void:
	base_resource.set("continue_previous_text", button_pressed)
	resource_value_modified()


func _on_CharacterSelector_character_selected(character:DialogCharacterResource) -> void:
	base_resource.set("character", character)
	resource_value_modified()
