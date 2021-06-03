tool
extends PanelContainer

signal save_requested
signal remove_requested(portrait)

export(NodePath) var PortraitIcon_path:NodePath
export(NodePath) var PortraitName_path:NodePath
export(NodePath) var PortraitNameEdit_path:NodePath
export(NodePath) var RemovePortrait_path:NodePath
export(NodePath) var PortraitContent_path:NodePath
export(NodePath) var PortraitImage_path:NodePath
export(NodePath) var FileDialog_path:NodePath

var base_resource:DialogPortraitResource = null
var expanded:bool = false

onready var portrait_icon_node:Button = get_node(PortraitIcon_path) as Button
onready var portrait_name_node:Button = get_node(PortraitName_path) as Button
onready var portrait_name_edit_node:LineEdit = get_node(PortraitNameEdit_path) as LineEdit
onready var portrait_remove_node:Button = get_node(RemovePortrait_path) as Button
onready var portrait_content_node:Container = get_node(PortraitContent_path) as Container
onready var portrait_image_node:Button = get_node(PortraitImage_path) as Button
onready var file_dialog_node:FileDialog = get_node(FileDialog_path) as FileDialog


func _ready() -> void:
	if base_resource:
		_update_values()
	

func _update_values() -> void:
	if expanded:
		portrait_content_node.visible = true
	portrait_name_node.text = base_resource.name
	portrait_name_edit_node.text = base_resource.name
	portrait_name_edit_node.placeholder_text = base_resource.name
	portrait_icon_node.icon = base_resource.icon
	portrait_image_node.icon = base_resource.image
	


func _on_PotraitName_pressed() -> void:
	portrait_name_node.visible = false
	portrait_name_edit_node.visible = true
	portrait_name_edit_node.grab_focus()


func _on_PortraitNameEdit_text_entered(new_text: String) -> void:
	grab_focus()
	portrait_name_edit_node.visible = false
	portrait_name_node.visible = true
	if base_resource and new_text:
		base_resource.name = new_text
		emit_signal("save_requested")


func _on_PortraitNameEdit_focus_exited() -> void:
	grab_focus()
	portrait_name_edit_node.visible = false
	portrait_name_node.visible = true


func _on_RemoveButton_pressed() -> void:
	emit_signal("remove_requested", base_resource)


func _on_ExpandButton_pressed() -> void:
	portrait_content_node.visible = !portrait_content_node.visible


func _on_PortraitImage_pressed() -> void:
	file_dialog_node.popup_centered_ratio()


func _on_FileDialog_file_selected(path: String) -> void:
	var _image = load(path)
	if _image is Texture:
		base_resource.image = _image
		emit_signal("save_requested")


func _on_RemoveImage_pressed() -> void:
	base_resource.image = null
	emit_signal("save_requested")


func _on_PortraitIcon_pressed() -> void:
	pass # Replace with function body.
