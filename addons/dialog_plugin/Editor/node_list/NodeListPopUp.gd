tool
extends PopupPanel

signal item_selected(item)
signal new_item_requested()

onready var node_list := $VBoxContainer/NodeList


func _draw() -> void:
	if not visible:
		clear()


func add_item(item_name:String, item_resource:Resource=null) -> void:
	node_list.add_item(item_name, item_resource)

func clear() -> void:
	node_list.clear()


func _on_NewItemButton_pressed() -> void:
	emit_signal("new_item_requested")


func _on_NodeListPopUp_popup_hide() -> void:
	clear()


func _on_NodeList_item_selected(item) -> void:
	if not item:
		return
	emit_signal("item_selected", item)
