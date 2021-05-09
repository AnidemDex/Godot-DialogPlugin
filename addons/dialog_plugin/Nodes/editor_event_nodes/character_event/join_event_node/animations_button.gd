tool
extends OptionButton

func _ready() -> void:
	_add_items()

func _add_items() -> void:
	clear()
	var idx = 0
	for key in DialogPortraitManager.PAnimation:
		add_item(key.capitalize())
		set_item_metadata(idx, DialogPortraitManager.PAnimation[key])
		idx += 1
