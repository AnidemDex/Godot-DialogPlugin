tool
extends DialogEditorEventNode

export(NodePath) var CharacterBtn_path:NodePath
export(NodePath) var PortraitBtn_path:NodePath

onready var character_button_node:OptionButton = get_node(CharacterBtn_path) as OptionButton
onready var portrait_button_node:OptionButton = get_node(PortraitBtn_path) as OptionButton

func _ready() -> void:
	if base_resource:
		character_button_node.generate_items()
		_update_node_values()


func _update_node_values() -> void:
	var _base:DialogCharacterChangeExpressionEvent = base_resource
	var _char:DialogCharacterResource = _base.character
	
	portrait_button_node.character = _char
	
	if _char:
		var _selected_portrait:DialogPortraitResource = _char.portraits.get_resources()[_base.selected_portrait]
		portrait_button_node.select_item_by_resource(_selected_portrait)
		character_button_node.select_item_by_resource(_char)


func _on_CharactersButton_item_selected(index: int) -> void:
	var _char_metadata = character_button_node.get_selected_metadata()
	if _char_metadata is Dictionary:
		base_resource.character = (_char_metadata as Dictionary).get("character", null)
	else:
		base_resource.character = null
	_save_resource()
	_update_node_values()


func _on_PortraitsButton_item_selected(index: int) -> void:
	var _portrait_metadata = portrait_button_node.get_selected_metadata()
	if _portrait_metadata is Dictionary:
		var _portraits:Array = base_resource.character.portraits.get_resources()
		var _selected_portrait = (_portrait_metadata as Dictionary).get("portrait")
		base_resource.selected_portrait = _portraits.find(_selected_portrait)
	else:
		base_resource.selected_portrait = 0
	
	_save_resource()
	_update_node_values()
