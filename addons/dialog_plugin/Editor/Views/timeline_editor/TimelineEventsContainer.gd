tool
extends VBoxContainer

signal item_added(item)

func can_drop_data(position, data):
	return data is DialogEventResource

func drop_data(position, data):
	emit_signal("item_added", data)
