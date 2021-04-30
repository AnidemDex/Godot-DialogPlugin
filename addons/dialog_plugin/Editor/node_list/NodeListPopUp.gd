tool
extends PopupPanel

signal item_selected(item)
signal new_item_requested()
signal deletion_requested(item)

var items:Array = [] setget _set_items

onready var node_list := $VBoxContainer/NodeList

func _draw() -> void:
	if not visible:
		clear()


func add_item(item_resource:Resource=null) -> void:
	node_list.add_item(item_resource)


func clear() -> void:
	node_list.clear()


func _set_items(value:Array) -> void:
	items = value
	if node_list:
		node_list.items = value
		node_list.update_view()


func _on_NewItemButton_pressed() -> void:
	emit_signal("new_item_requested")


func _on_NodeListPopUp_popup_hide() -> void:
	clear()


func _on_NodeList_item_selected(item) -> void:
	if not item:
		return
	emit_signal("item_selected", item)


func _on_NodeList_deletion_requested(item) -> void:
	if not item:
		return
	emit_signal("deletion_requested", item)
	pass # Replace with function body.
