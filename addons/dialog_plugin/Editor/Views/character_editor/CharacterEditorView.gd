tool
extends VBoxContainer

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")

var base_resource:DialogCharacterResource = null setget _set_base_resource

export(NodePath) var Name_path:NodePath
export(NodePath) var DisplayName_path:NodePath
export(NodePath) var Icon_path:NodePath
export(NodePath) var PortraitContainer_path:NodePath

export(String, FILE) var debug_base_resource:String = ""

onready var name_node:Label = get_node(Name_path) as Label
onready var display_name_node:LineEdit = get_node(DisplayName_path) as LineEdit
onready var icon_node:Button = get_node(Icon_path) as Button
onready var portrait_container_node := get_node(PortraitContainer_path)

func get_class() -> String: return "CharacterEditorView"

func _ready() -> void:
	if (not Engine.editor_hint) and (debug_base_resource != ""):
		base_resource = load(debug_base_resource) as DialogCharacterResource


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		if visible and base_resource:
			configure_resource()
			update_values()


func configure_resource() -> void:
	if not base_resource.is_connected("changed", self, "update_values"):
		base_resource.connect("changed", self, "update_values")


func update_values() -> void:
	name_node.text = base_resource.name
	display_name_node.text = base_resource.display_name
	icon_node.icon = base_resource.icon
	portrait_container_node.character = base_resource
	portrait_container_node._update_values()


func _set_base_resource(value:DialogCharacterResource) -> void:
	if base_resource and base_resource.is_connected("changed", self, "update_values"):
		base_resource.disconnect("changed", self, "update_values")
	
	base_resource = value
	configure_resource()


func _save() -> void:
	if not base_resource:
		return
	call_deferred("_deferred_save")


func _deferred_save(_descarted_value=null) -> void:
	DialogUtil.Logger.print_debug(self, "Saving a resource.")
	if not base_resource:
		DialogUtil.Logger.print_debug(self, "There's no resource to save. Skipping")
		return
	var path:String = base_resource.resource_path
	if "::" in path:
		DialogUtil.Logger.print_debug(self, "Trying to save a sub-resource. Skipping")
	else:
		var _err = ResourceSaver.save(base_resource.resource_path, base_resource)
		DialogUtil.Logger.verify(_err == OK, "There was an error while saving a resource in {path}: {error}".format({"path":base_resource.resource_path, "error":_err}))


func _on_DisplayName_text_changed(new_text: String) -> void:
	if not base_resource:
		return
	base_resource.display_name = new_text


func _on_DefaultspeakerButton_toggled(button_pressed: bool) -> void:
	if not base_resource:
		return
	base_resource.default_speaker = button_pressed


func _on_RemoveIconBtn_pressed() -> void:
	icon_node.text = "icon"
	base_resource.icon = null


func _on_Icon_resource_selected(resource:Texture) -> void:
	base_resource.icon = resource
