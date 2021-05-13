tool
extends OptionButton

func _ready() -> void:
	clear()
	add_item("Empty")
	select(0)

# Override this method
# Generate the required items with its needed metadata to be used later
func generate_items() -> void:
	assert(false)


# This method probably will fall if there's 2 characters with the same name
func select_item_by_name(name:String) -> void:
	for _item_idx in range(get_item_count()):
		var _idx = clamp(_item_idx-1, 0, get_item_count())
		var _item_text = get_item_text(_idx)
		if _item_text == name:
			select(_idx)


func select_item_by_resource(resource) -> void:
	for _item_idx in range(get_item_count()):
		var _idx = clamp(_item_idx, 0, get_item_count())
		var _item_resource = get_item_metadata(_idx)
		if _item_resource and _item_resource is Dictionary:
			if resource in _item_resource.values():
				select(_idx)
