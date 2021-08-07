tool
class_name DialogCharacterChangeExpressionEvent
extends DialogCharacterEvent


func _init() -> void:
	resource_name = "CharacterChangeExpression"
	event_name = "Change Expression"
	event_icon = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/character/change_expression.png") as Texture
	skip = true


func execute(caller:DialogBaseNode) -> void:
	if not caller.PortraitManager or not character:
		finish(true)
		return
	
	var _PortraitManager:DialogPortraitManager = caller.PortraitManager
	
	_PortraitManager.change_portrait(character, get_selected_portrait())
	
	finish()
