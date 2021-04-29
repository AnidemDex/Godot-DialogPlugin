tool
extends ScrollContainer
# This is supposed to be a node list, but it uses Resources as item base
# For now, everything only work if you are adding resources, not nodes.
# Maybe I have to rename this as 'ResourceList' instead?

signal item_selected(item)
signal deletion_requested(item)

const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")

export(PackedScene) var ItemScene:PackedScene = load("res://addons/dialog_plugin/Editor/node_list/item/item.tscn")
export(PackedScene) var FolderScene:PackedScene = load("res://addons/dialog_plugin/Editor/node_list/folder_container/folder_container.tscn")

# [{Resource:Node}]
# Maybe, just maybe, with this i can create folders
var items:Array = []
# [{"base_dir":Node}]
var folders:Array = []

var folder_name_exceptions = [
	DialogResources.TIMELINES_DIR.get_base_dir().split("/")[-1],
	DialogResources.CHARACTERS_DIR.get_base_dir().split("/")[-1],
	]

onready var node_container = $Panel/NodeContainer

func add_item(item_resource:Resource=null) -> void:
	var _item_node:Control = null
	for item in items:
		_item_node = (item as Dictionary).get(item_resource, null)
	if not _item_node:
		items.append({item_resource:null})
	
	update_view()

func update_view() -> void:
	clear()
	
	for item in items:
		for item_resource in (item as Dictionary).keys():
			
			var _item_node = (item as Dictionary).get(item_resource, null)
			var _item_path:String = item_resource.resource_path
			var _item_folder:String = _item_path.get_base_dir().split("/")[-1]
			
			if not _item_node:
				_item_node = ItemScene.instance()
			
			
			_item_node.name = item_resource.resource_path.get_file().replace(".tres","")
			_item_node.text = _item_node.name
			_item_node.set_meta("base_resource", item_resource)
			
			if not(_item_node.is_connected("pressed", self, "_on_item_selected")):
				_item_node.connect("pressed", self, "_on_item_selected")
			if not(_item_node.is_connected("deletion_requested", self, "_on_item_deletion_requested")):
				_item_node.connect("deletion_requested", self, "_on_item_deletion_requested")
			
			if _item_folder in folder_name_exceptions:
				node_container.add_child(_item_node)
			else:
				var _node_folder = null
				for folder in folders:
					# First, check if we added the folder previously
					if _item_folder in folder:
						_node_folder = folder[_item_folder]
				# Then, if there's no folder or the previous instance doesn't exist
				# creates a new folder and update values
				if not _node_folder or not(is_instance_valid(_node_folder)):
					_node_folder = FolderScene.instance()
					folders.append({_item_folder:_node_folder})
					node_container.add_child(_node_folder)
					_node_folder.name = _item_folder
					_node_folder.folder_name.text = _item_folder
				_node_folder.node_container.add_child(_item_node)
				node_container.move_child(_node_folder, 0)

func clear() -> void:
	for child in node_container.get_children():
		child.queue_free()


func _on_item_selected(item:Control=null) -> void:
	if not item:
		return
	emit_signal("item_selected", item.get_meta("base_resource"))


func _on_item_deletion_requested(item:Control=null) -> void:
	if not item:
		return
	emit_signal("deletion_requested", item.get_meta("base_resource"))
