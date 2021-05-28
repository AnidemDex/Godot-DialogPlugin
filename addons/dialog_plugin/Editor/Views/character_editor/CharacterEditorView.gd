tool
extends VBoxContainer

var base_resource:DialogCharacterResource = null setget _set_base_resource

export(NodePath) var Name_path:NodePath
export(NodePath) var DisplayName_path:NodePath
export(NodePath) var Icon_path:NodePath
export(NodePath) var PortraitContainer_path:NodePath

onready var name_node:Label = get_node(Name_path) as Label
onready var display_name_node:LineEdit = get_node(DisplayName_path) as LineEdit
onready var icon_node:Button = get_node(Icon_path) as Button
onready var portrait_container_node := get_node(PortraitContainer_path)

func _ready() -> void:
	if not base_resource:
		return
	if not base_resource.is_connected("changed", self, "_on_BaseResource_changed"):
		var _err = base_resource.connect("changed", self, "_on_BaseResource_changed")
		assert(_err == OK)
	_update_values()

func _update_values() -> void:
	visible = true
	name_node.text = base_resource.name
	display_name_node.text = base_resource.display_name
	icon_node.icon = base_resource.icon
	portrait_container_node.base_resource = base_resource


func _set_base_resource(value:DialogCharacterResource) -> void:
	base_resource = value
	if not base_resource.is_connected("changed", self, "_on_BaseResource_changed"):
		base_resource.connect("changed", self, "_on_BaseResource_changed")
	
	if is_inside_tree():
		_update_values()


func _save() -> void:
	if not base_resource:
		return
	var _err = ResourceSaver.save(base_resource.resource_path, base_resource)
	assert(_err == OK)


func _on_BaseResource_changed() -> void:
	_update_values()


func _on_DisplayName_text_changed(new_text: String) -> void:
	if not base_resource:
		return
	base_resource.display_name = new_text


func _on_DefaultspeakerButton_toggled(button_pressed: bool) -> void:
	if not base_resource:
		return
	base_resource.default_speaker = button_pressed
	_save()


func _on_Icon_pressed() -> void:
	$FileDialog.popup_centered_ratio()


func _on_FileDialog_file_selected(path: String) -> void:
	var _image = load(path)
	if _image is Texture:
		base_resource.icon = _image
		_save()
		_update_values()


func _on_RemoveIconBtn_pressed() -> void:
	base_resource.icon = null
	_save()
	_update_values()
