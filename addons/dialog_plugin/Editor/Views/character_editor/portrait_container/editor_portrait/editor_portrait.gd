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

var portrait:DialogPortraitResource = null
var expanded:bool = false

onready var portrait_icon_node:Button = get_node(PortraitIcon_path) as Button
onready var portrait_name_node:Button = get_node(PortraitName_path) as Button
onready var portrait_name_edit_node:LineEdit = get_node(PortraitNameEdit_path) as LineEdit
onready var portrait_remove_node:Button = get_node(RemovePortrait_path) as Button
onready var portrait_content_node:Container = get_node(PortraitContent_path) as Container
onready var portrait_image_node:Button = get_node(PortraitImage_path) as Button


func _ready() -> void:
	if portrait:
		_update_values()
	

func _update_values() -> void:
	portrait_content_node.visible = expanded
	portrait_name_node.text = portrait.name
	portrait_name_edit_node.text = portrait.name
	portrait_name_edit_node.placeholder_text = portrait.name
	if portrait.icon:
		portrait_icon_node.icon = portrait.icon
	portrait_image_node.icon = portrait.image
	


func _on_PotraitName_pressed() -> void:
	portrait_name_node.visible = false
	portrait_name_edit_node.visible = true
	portrait_name_edit_node.grab_focus()


func _on_PortraitNameEdit_text_entered(new_text: String) -> void:
	portrait_name_edit_node.release_focus()
	portrait_name_edit_node.visible = false
	portrait_name_node.visible = true
	if portrait and new_text:
		portrait.name = new_text
		emit_signal("save_requested")


func _on_PortraitNameEdit_focus_exited() -> void:
	portrait_name_edit_node.visible = false
	portrait_name_node.visible = true


func _on_RemoveButton_pressed() -> void:
	emit_signal("remove_requested", portrait)


func _on_ExpandButton_pressed() -> void:
	portrait_content_node.visible = !portrait_content_node.visible


func _on_RemoveImage_pressed() -> void:
	portrait.image = null
	emit_signal("save_requested")


func _on_PortraitIcon_resource_selected(resource:Texture) -> void:
	portrait.icon = resource


func _on_PortraitImage_resource_selected(resource:Texture) -> void:
	portrait.image = resource
