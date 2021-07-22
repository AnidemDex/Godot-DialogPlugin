tool
extends PanelContainer

signal save_requested

export(PackedScene) var EditorPortrait_scene:PackedScene = null
export(NodePath) var AddItemBtn_path:NodePath
export(NodePath) var FileDialog_path:NodePath
export(NodePath) var Portraits:NodePath

var character:DialogCharacterResource
var last_pressed_button = null

onready var add_item_node := get_node(AddItemBtn_path)
onready var portraits_node:Container = get_node(Portraits) as Container
onready var file_dialog_node:FileDialog = get_node(FileDialog_path) as FileDialog


func _save():
	if not character:
		return
	emit_signal("save_requested")
	_update_values()


func _unload_values() -> void:
	for _child in portraits_node.get_children():
		_child.queue_free()


func _update_values() -> void:
	_unload_values()
	var _e = false
	if character.portraits.size() < 10:
		_e = true
	for portrait in character.portraits:
		_add_item(portrait, _e)


func _add_item(portrait:DialogPortraitResource, expanded=false) -> void:
	var _editor_portrait_node = EditorPortrait_scene.instance()
	_editor_portrait_node.portrait = portrait
	
	if not _editor_portrait_node.is_connected("save_requested", self, "_save"):
		_editor_portrait_node.connect("save_requested", self, "_save")
	if not _editor_portrait_node.is_connected("remove_requested", self, "_on_PortraitNode_remove_requested"):
		_editor_portrait_node.connect("remove_requested", self, "_on_PortraitNode_remove_requested")
	
	_editor_portrait_node.expanded = expanded
	
	portraits_node.add_child(_editor_portrait_node)


func _on_AddItemBtn_pressed() -> void:
	var _new_portrait = DialogPortraitResource.new()
	_new_portrait.name = "New Portrait"
	character.add_portrait(_new_portrait)
	_save()


func _on_BaseResource_changed():
	_update_values()


func _on_PortraitNode_remove_requested(portrait:DialogPortraitResource) -> void:
	character.remove_portrait(portrait)
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
		
		character.add_portrait(_new_portrait)
	
	_save()


func _on_AddManyItemsBtn_pressed() -> void:
	file_dialog_node.popup_centered_ratio()
