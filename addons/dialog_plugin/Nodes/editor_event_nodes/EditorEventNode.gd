tool
class_name DialogEditorEventNode
extends Control

signal deletion_requested(item)
signal save_item_requested(item)
signal event_being_dragged()
# Your script needs an timeline_resource property in order to get this signal
# working properly
signal timeline_requested(emitter_node)

const DEFAULT_COLOR = Color("#999999")
const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")

var DialogUtil := load("res://addons/dialog_plugin/Core/DialogUtil.gd")
# Te voy a comentar esto por si se te llega a olvidar:
# base_resource es un DialogEventResource relacionado al evento
# que va a modificar. Por ejemplo, en el nodo de TextEvent
# tendrás un base_resource de DialogTextEvent
var base_resource:Resource = null
var idx:int = 0 setget _set_idx

var _is_focused = false

# Considera remover esta variable
var _stylebox:StyleBoxFlat

export(Color) var event_color = Color("3c3d5e") setget _set_event_color

export(NodePath) var IconNode_path:NodePath
export(NodePath) var TopContent_path:NodePath
export(NodePath) var PropertiesContainer_path:NodePath
export(NodePath) var IndexLbl_path:NodePath
export(NodePath) var SkipBtn_path:NodePath

var EventName_Path:NodePath = "HContainer/HContainer/NameMargin/EventName"

onready var top_content_node:PanelContainer = get_node(TopContent_path) as PanelContainer
onready var properties_content_node:PanelContainer = get_node(PropertiesContainer_path) as PanelContainer
onready var icon_node:TextureRect = get_node(IconNode_path) as TextureRect
onready var index_label_node:Label = get_node(IndexLbl_path) as Label
onready var skip_button_node:CheckBox = get_node(SkipBtn_path) as CheckBox
onready var event_name_container:Container = get_node(EventName_Path) as Container

func _ready() -> void:
	
	event_name_container.set_drag_forwarding(self)
	
	if not base_resource:
		DialogUtil.Logger.print(self,["There's no resource reference for this event", name])
		return
	
	if not base_resource.is_connected("changed", self, "_on_resource_change"):
		base_resource.connect("changed", self, "_on_resource_change")
	
	skip_button_node.pressed = base_resource.skip


func get_drag_data_fw(position: Vector2, from_control:Control):
	if not base_resource:
		return
	var data = base_resource
	var drag_preview_node:Control = data.get_event_editor_node()
	drag_preview_node.size_flags_horizontal = Control.SIZE_FILL
	drag_preview_node.size_flags_vertical = Control.SIZE_FILL
	drag_preview_node.anchor_right = 0
	drag_preview_node.anchor_bottom = 0
	drag_preview_node.rect_size = Vector2(50,50)
	drag_preview_node.rect_min_size = Vector2(50,50)
	set_drag_preview(drag_preview_node)
	emit_signal("deletion_requested", base_resource)
	emit_signal("event_being_dragged")
	return data


func _draw() -> void:
	var _focus_owner = get_focus_owner()
	if has_focus():
		_focused()
	elif _focus_owner and is_a_parent_of(_focus_owner):
		_focused()
	else:
		_unfocused()


func _clips_input() -> bool:
	return true


func _get_minimum_size() -> Vector2:
	return Vector2(0,32)


func _focused() -> void:
	_is_focused = true
	emit_signal("focus_entered", self)
	
	var _top_container_node = top_content_node.get_node("HContainer")
	if not _top_container_node:
		return
	
	_stylebox = top_content_node.get_stylebox("panel") as StyleBoxFlat
	_stylebox.bg_color = event_color
	_stylebox = properties_content_node.get_stylebox("panel") as StyleBoxFlat
	_stylebox.bg_color = event_color
	
	_top_container_node.toggle(true)


func _unfocused() -> void:
	_is_focused = false
	emit_signal("focus_exited", self)
	
	var _top_container_node = top_content_node.get_node("HContainer")
	if not _top_container_node:
		return
	
	_top_container_node.toggle(false)
	_stylebox = top_content_node.get_stylebox("panel") as StyleBoxFlat
	_stylebox.bg_color = DEFAULT_COLOR
	_stylebox = properties_content_node.get_stylebox("panel") as StyleBoxFlat
	_stylebox.bg_color = DEFAULT_COLOR


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			update()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.scancode == KEY_DELETE and event.pressed and _is_focused:
			accept_event()
			emit_signal("deletion_requested", base_resource)


func _set_idx(value):
	if index_label_node:
		idx = value
		index_label_node.text = str(value)


func _update_node_values() -> void:
	assert(false, "You forgot to override '_update_node_values' method")


func _save_resource() -> void:
	emit_signal("save_item_requested", base_resource)


func _set_event_color(value:Color) -> void:
	event_color = value
	
	if event_name_container:
		event_name_container.get_stylebox("panel").bg_color = event_color
	property_list_changed_notify()


func _on_resource_change() -> void:
	_update_node_values()


func _on_SkipButton_toggled(button_pressed: bool) -> void:
	if base_resource:
		base_resource.skip = button_pressed
		_save_resource()
