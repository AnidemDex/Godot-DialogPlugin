tool
extends PanelContainer

export(PackedScene) var EditorPortrait_scene:PackedScene = null
export(NodePath) var AddItemBtn_path:NodePath
export(NodePath) var FileDialog_path:NodePath
export(NodePath) var Portraits:NodePath

var base_resource:DialogCharacterResource setget _set_base_resource
var last_pressed_button = null

onready var add_item_node := get_node(AddItemBtn_path)
onready var portraits_node:Container = get_node(Portraits) as Container
onready var file_dialog_node:FileDialog = get_node(FileDialog_path) as FileDialog


func _save():
	if not base_resource:
		return
	var _err = ResourceSaver.save(base_resource.resource_path, base_resource)
	assert(_err == OK)
	_update_values()


func _unload_values() -> void:
	for _child in portraits_node.get_children():
		_child.queue_free()


func _update_values() -> void:
	_unload_values()
	for portrait in base_resource.portraits:
		_add_item(portrait)


func _add_item(portrait:DialogPortraitResource) -> void:
	var _editor_portrait_node = EditorPortrait_scene.instance()
	_editor_portrait_node.base_resource = portrait
	
	if not _editor_portrait_node.is_connected("save_requested", self, "_save"):
		_editor_portrait_node.connect("save_requested", self, "_save")
	if not _editor_portrait_node.is_connected("remove_requested", self, "_on_PortraitNode_remove_requested"):
		_editor_portrait_node.connect("remove_requested", self, "_on_PortraitNode_remove_requested")
	
	portraits_node.add_child(_editor_portrait_node)


func _set_base_resource(value:DialogCharacterResource):
	base_resource = value
	if not base_resource.is_connected("changed", self, "_on_BaseResource_changed"):
		base_resource.connect("changed", self, "_on_BaseResource_changed")
	_update_values()


func _on_AddItemBtn_pressed() -> void:
	var _new_portrait = DialogPortraitResource.new()
	_new_portrait.name = "New Portrait"
	base_resource.portraits.add(_new_portrait)
	_save()


func _on_BaseResource_changed():
	_update_values()


func _on_PortraitButton_pressed(button:Button=null) -> void:
	if not button:
		return
	last_pressed_button = button
	if not file_dialog_node:
		var _file_dialog = get_node(FileDialog_path)
		if Engine.editor_hint:
			var _editor_interface = EditorPlugin.new().get_editor_interface()
			var _base_control = _editor_interface.get_base_control()
			file_dialog_node = _file_dialog.duplicate()
			_base_control.add_child(file_dialog_node)
		else:
			file_dialog_node = _file_dialog
			
			
	file_dialog_node.popup_centered_ratio()


func _on_PortraitNode_remove_requested(portrait:DialogPortraitResource) -> void:
	base_resource.portraits.remove(portrait)
	_save()


func _on_FileDialog_files_selected(paths: PoolStringArray) -> void:
	for image_path in paths:
		image_path = image_path as String

		var _image = load(image_path)
		
		if not(_image is Texture):
			push_warning("Unknow file, skipping")
			continue
		
		var _new_portrait = DialogPortraitResource.new()
		_new_portrait.name = image_path.get_file().replace("."+image_path.get_extension(), "")
		_new_portrait.image = _image
		
		base_resource.portraits.add(_new_portrait)
	
	_save()


func _on_AddManyItemsBtn_pressed() -> void:
	file_dialog_node.popup_centered_ratio()
