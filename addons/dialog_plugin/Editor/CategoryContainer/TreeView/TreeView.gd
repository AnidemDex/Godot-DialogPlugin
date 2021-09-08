tool
extends Tree

# Takes care about the tree behaviour
# Here is where the magic is done

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")

var base_resource = null setget _set_base

var root

func _ready() -> void:
	root = create_item()
	set_hide_root(true)

	if base_resource:
		update_tree()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.scancode == KEY_DELETE and not event.echo:
		if not event.pressed and get_selected():
			remove_item(get_selected())


func update_tree() -> void:
	if not base_resource:
		DialogUtil.Logger.print(self,"No base resource")
		return

	if get_root():
		get_root().free()
		clear()
		root = create_item()
	
	for resource in base_resource.resources.get_resources():
		create_tree_item(resource)


func create_tree_item(with_resource:Resource)->void:
	
	var _resource = with_resource
	
	if not _resource:
		DialogUtil.Logger.print(self,"no resource")
		return
	
	DialogUtil.Logger.print(self,["Creating a new tree item with:", with_resource.resource_path.get_file()])
	
	if _resource is EncodedObjectAsID:
		_resource = instance_from_id(_resource.object_id)
		DialogUtil.Logger.print(self,["get resource by id:", _resource])
	
	if not is_instance_valid(_resource):
		DialogUtil.Logger.print(self,["instance is not valid",_resource])
		return
	
	var _item = create_item()
	_item.set_text(0, _resource.resource_name)
	_item.set_tooltip(0, _resource.resource_path)
	_item.set_metadata(0, _resource)
	DialogUtil.Logger.print(self,"Tree item created")

func remove_item(item:TreeItem = null):
	if not item:
		return
	DialogUtil.Logger.print(self,["Attempt to delete item", item.get_metadata(0)])
	base_resource.remove(item.get_metadata(0))

func rename_item(item:TreeItem = null):
	item.set_editable(0, true)

func _set_base(resource:Resource):
	# Look at this little and pottentially breaking code line. I hate him
	# This can tolerate any kind of resource, but it should
	# had .resources as ResourceArray
	base_resource = resource
	if not base_resource:
		base_resource = null
		return
	if not(base_resource.is_connected("changed",self,"update_tree")):
		base_resource.connect("changed",self,"update_tree")
	update_tree()

func _on_base_resource_change():
	update_tree()
