tool
extends HBoxContainer

signal character_selected(character)

func _on_LineEdit_text_entered(new_text: String) -> void:
	var character := DialogCharacterResource.new()
	character.name = new_text
	emit_signal("character_selected", character)


func _on_ResourceSelector_resource_selected(resource:Resource) -> void:
	if resource is DialogCharacterResource:
		$LineEdit.text = resource.display_name
		emit_signal("character_selected", resource)


func set_character(character:String) -> void:
	$LineEdit.text = character
