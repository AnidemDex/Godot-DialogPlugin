tool
class_name DialogCharacterLeaveEvent
extends DialogCharacterEvent

func _init():
	resource_name = "CharacterLeaveEvent"
	event_icon = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/character/character_leave.png") as Texture
	skip = true


func execute(caller:DialogBaseNode) -> void:
	var PortraitManager:DialogPortraitManager = caller.PortraitManager
	if not PortraitManager:
		finish(true)
		return
	
	if not character:
		var _characters = PortraitManager.portraits.keys()
		for _chara in _characters:
			PortraitManager.remove_portrait(_chara)
		PortraitManager.portraits.clear()
	else:
		PortraitManager.remove_portrait(character)
	
	finish(skip)


func _get(property: String):
	if property == "selected_portrait_ignore":
		return true
