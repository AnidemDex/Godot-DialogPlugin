tool
extends "res://addons/dialog_plugin/Nodes/misc/OptionButtonGenerator.gd"

signal character_added

var characters = [] setget _set_characters

func generate_items() -> void:
	clear()
	add_item("None")

	var _idx = 1
	for character in characters:
		character = character as DialogCharacterResource
		
		add_item(character.display_name)
		set_item_metadata(_idx, {"character":character})
		
		_idx += 1
	add_separator()
	add_icon_item(get_icon("Folder", "EditorIcons"), "Select Character")


func _set_characters(value:Array) -> void:
	characters = value
	generate_items()

func _on_CharacterList_item_selected(index: int) -> void:
	if get_item_text(index) == "Select Character" and get_item_metadata(index) == null:
		$FileDialog.popup_centered_ratio()


func _on_FileDialog_file_selected(path: String) -> void:
	var _character = load(path)
	
	if _character is DialogCharacterResource:
		characters.append(_character)
		generate_items()
		select_item_by_resource(_character)
		emit_signal("character_added")
