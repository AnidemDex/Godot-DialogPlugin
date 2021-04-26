tool
extends ScrollContainer

signal item_selected(item)

export(PackedScene) var ItemScene = load("res://addons/dialog_plugin/Editor/node_list/item/item.tscn")

func add_item(item_name:String, item_resource:Resource=null) -> void:
	var _item = ItemScene.instance()
	_item.name = item_name.capitalize()
	_item.text = item_name
	_item.set_meta("base_resource", item_resource)
	_item.connect("pressed", self, "_on_item_selected")
	$NodeContainer.add_child(_item)

func clear() -> void:
	for child in $NodeContainer.get_children():
		child.queue_free()

func _on_item_selected(item:Control=null) -> void:
	if not item:
		return
	emit_signal("item_selected", item.get_meta("base_resource"))
