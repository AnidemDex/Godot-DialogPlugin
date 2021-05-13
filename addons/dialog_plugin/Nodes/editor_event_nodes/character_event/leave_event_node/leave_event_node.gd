tool
extends DialogEditorEventNode

export(NodePath) var CharacterBtn_path:NodePath

onready var character_button_node:OptionButton = get_node(CharacterBtn_path)

func _ready() -> void:
	if base_resource:
		character_button_node.generate_items()
		_update_node_values()


func _update_node_values() -> void:
	var _base:DialogCharacterLeaveEvent = base_resource
	var _char:DialogCharacterResource = _base.character
	
	if _char:
		character_button_node.select_item_by_resource(_char)


func _on_CharactersButton_item_selected(index: int) -> void:
	var _char_metadata = character_button_node.get_selected_metadata()
	if _char_metadata is Dictionary:
		base_resource.character = (_char_metadata as Dictionary).get("character", null)
	else:
		base_resource.character = null
	_save_resource()
	_update_node_values()
