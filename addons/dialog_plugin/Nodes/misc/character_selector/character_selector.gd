tool
extends HBoxContainer

signal character_selected(character)

var filters:PoolStringArray = PoolStringArray([])

onready var line_edit_node:LineEdit = $LineEdit as LineEdit

func _ready() -> void:
	$ResourceSelector.filters = filters


func _on_LineEdit_text_entered(new_text: String) -> void:
	if new_text == "":
		emit_signal("character_selected", null)
		return
	
	var character := DialogCharacterResource.new()
	character.name = new_text
	emit_signal("character_selected", character)


func _on_ResourceSelector_resource_selected(resource:Resource) -> void:
	if resource is DialogCharacterResource:
		line_edit_node.text = resource.display_name
		emit_signal("character_selected", resource)
	if resource == null:
		line_edit_node.text = ""
		emit_signal("character_selected", resource)
		


func set_character(character:String) -> void:
	line_edit_node.text = character
