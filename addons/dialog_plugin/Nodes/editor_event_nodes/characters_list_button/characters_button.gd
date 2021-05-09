tool
extends OptionButton

const DialogDB = preload("res://addons/dialog_plugin/Core/DialogDatabase.gd")
const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")

const ICON_PATH = "res://addons/dialog_plugin/assets/Images/Event Icons/character.svg"

var _char_db = null

func _ready() -> void:
	_char_db = DialogDB.Characters.get_database()
	
	clear()
	
	add_item("[Empty]")
	select(0)

func generate_items() -> void:
	var _idx = 1
	for resource in _char_db.resources.get_resources():
		
		DialogUtil.Logger.print(self,"Creating a character item")
		
		var _char = resource
		var _char_icon = load(ICON_PATH)
		add_icon_item(_char_icon, _char.display_name)
		set_item_metadata(_idx, {"character":_char})
		_idx += 1


# This method probably will fall if there's 2 characters with the same name
func select_item_by_name(name:String) -> void:
	for _item_idx in range(get_item_count()):
		var _idx = clamp(_item_idx-1, 0, get_item_count())
		var _item_text = get_item_text(_idx)
		if _item_text == name:
			select(_idx)

func select_item_by_resource(resource:DialogCharacterResource) -> void:
	for _item_idx in range(get_item_count()):
		var _idx = clamp(_item_idx, 0, get_item_count())
		var _item_resource = get_item_metadata(_idx)
		if _item_resource is Dictionary and "character" in _item_resource:
			if _item_resource["character"] == resource:
				select(_idx)
