tool
extends MenuButton

signal item_selected(item_string)

export(PoolStringArray) var supported_types = PoolStringArray([])

onready var popup_menu:PopupMenu = get_popup()

func _ready() -> void:
	popup_menu.connect("index_pressed", self, "_on_PopupMenu_index_pressed")
	generate_items()


func generate_items() -> void:
	popup_menu.clear()
	for item in supported_types:
		popup_menu.add_item(item)


func _on_PopupMenu_index_pressed(idx:int=-1) -> void:
	var item_text:String = popup_menu.get_item_text(idx)
	emit_signal("item_selected", item_text)
