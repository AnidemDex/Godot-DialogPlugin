tool
extends VBoxContainer

signal timeline_selected(timeline)
signal character_selected(character)
signal variable_selected

const DialogDB = preload("res://addons/dialog_plugin/Core/DialogDatabase.gd")

onready var tool_buttons = $PanelContainer/ToolButtons
onready var info_label = $PanelContainer/InfoLabel

func _ready() -> void:
	tool_buttons.get_node("TimelinesButton").icon = get_icon("ListSelect", "EditorIcons")
	if $CheckBox.pressed:
		_show_toolbar()
	else:
		_hide_toolbar()


func _show_toolbar() -> void:
	tool_buttons.visible = true
	info_label.visible = false


func _hide_toolbar() -> void:
	tool_buttons.visible = false
	info_label.visible = true


func _on_CheckBox_toggled(button_pressed: bool) -> void:
	if button_pressed:
		_show_toolbar()
	else:
		_hide_toolbar()


func _on_TimelinesButton_pressed() -> void:
	var _position = $ReferenceRect.rect_global_position+Vector2(get_local_mouse_position().x,0)
	$TimelineListPopUp.rect_position = _position
	# Añade los items aqui
	var _timelines:Array = DialogDB.Timelines.get_timelines()
	var _items = []
	for timeline in _timelines:
		_items.append({timeline:null})
	$TimelineListPopUp.items = _items
	$TimelineListPopUp.popup()


func _on_TimelineListPopUp_new_item_requested() -> void:
	$TimelineListPopUp.visible = false
	$NewTimelinePopup.popup_centered()


func _on_NewTimelinePopup_confirmed() -> void:
	var _new_timeline_name = $NewTimelinePopup.text_node.text
	var _timeline = null
	DialogDB.Timelines.add(_new_timeline_name)
	_timeline = DialogDB.Timelines.get_timeline(_new_timeline_name)
	emit_signal("timeline_selected", _timeline)


func _on_TimelineListPopUp_item_selected(item) -> void:
	if not item:
		return
	emit_signal("timeline_selected", item)
	$TimelineListPopUp.hide()


func _on_TimelineListPopUp_deletion_requested(item) -> void:
	if not item:
		return
	$TimelineListPopUp.hide()
	# TODO: Mejorar este mensaje
	print("[Dialogic] Timeline resource {} will be removed from our database. If you really want to delete this item, remove it from your files".format({"":item.resource_path.get_file()}))
	DialogDB.Timelines.get_database().remove(item)


func _on_CharactersButton_pressed() -> void:
	var _position = $ReferenceRect.rect_global_position+Vector2(get_local_mouse_position().x,0)
	$CharacterListPopUp.rect_position = _position
	# Añade los items aqui
	var _characters:Array = DialogDB.Characters.get_characters()
	var _items = []
	for character in _characters:
		_items.append({character:null})
	$CharacterListPopUp.items = _items
	
	$CharacterListPopUp.popup()


func _on_CharacterListPopUp_new_item_requested() -> void:
	$CharacterListPopUp.hide()
	$NewCharacterPopup.popup_centered()


func _on_NewCharacterPopup_confirmed() -> void:
	var _new_character_name = $NewCharacterPopup.text_node.text
	var _character = null
	DialogDB.Characters.add(_new_character_name)
	_character = DialogDB.Characters.get_character(_new_character_name)
	emit_signal("character_selected", _character)


func _on_CharacterListPopUp_item_selected(item) -> void:
	if not item:
		return
	emit_signal("character_selected", item)
	$CharacterListPopUp.hide()


func _on_CharacterListPopUp_deletion_requested(item) -> void:
	$CharacterListPopUp.hide()
	# TODO: Mejorar este mensaje
	print("[Dialogic] Character resource {} will be removed from our database. If you really want to delete this item, remove it from your files".format({"":item.resource_path.get_file()}))
	DialogDB.Characters.get_database().remove(item)


func _on_VariablesButton_pressed() -> void:
	emit_signal("variable_selected")
