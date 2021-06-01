tool
extends DialogEditorEventNode

## Use _save_resource() method everywhere you update the base_resource
## properties. Then, call again _update_node_values if you want
export(NodePath) var CharacterBtn_path:NodePath
export(NodePath) var PortraitBtn_path:NodePath
export(NodePath) var PortraitContainer_path:NodePath

var timeline_resource:DialogTimelineResource = null setget _set_timeline

onready var character_button_node:OptionButton = get_node_or_null(CharacterBtn_path) as OptionButton
onready var portrait_button_node:OptionButton = get_node_or_null(PortraitBtn_path) as OptionButton
onready var portrait_container_node:Container = get_node_or_null(PortraitContainer_path) as Container

#base_resource:DialogCharacterEvent

func _ready() -> void:
	if get_tree().edited_scene_root == self:
		return


func _update_node_values() -> void:
	portrait_button_node.character = base_resource.character
	if base_resource.character:
		character_button_node.select_item_by_resource(base_resource.character)
		portrait_container_node.visible = true
		portrait_button_node.select_item_by_resource(base_resource.selected_portrait)
	else:
		portrait_container_node.visible = false


func _set_timeline(value:DialogTimelineResource) -> void:
	timeline_resource = value
	character_button_node.characters = value._related_characters
	_update_node_values()


func _on_CharacterList_character_added() -> void:
	_save_resource()
	_update_node_values()


func _on_CharacterList_item_selected(index: int) -> void:
	var _char_metadata = character_button_node.get_selected_metadata()
	if _char_metadata is Dictionary:
		base_resource.character = (_char_metadata as Dictionary).get("character", null)
	else:
		base_resource.character = null
		base_resource.selected_portrait = -1
	
	_save_resource()
	_update_node_values()


func _on_PortraitsList_item_selected(index: int) -> void:
	var _portrait_metadata = portrait_button_node.get_selected_metadata()
	if _portrait_metadata is Dictionary:
		base_resource.selected_portrait = _portrait_metadata.get("portrait", -1)
	else:
		base_resource.selected_portrait = -1
	_save_resource()
	_update_node_values()
