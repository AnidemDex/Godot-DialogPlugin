# tool
class_name DialogEditorEventNode
extends Control

signal deletion_requested(item)
signal event_modified
# Your script needs an timeline_resource property in order to get this signal
# working properly
signal timeline_requested(emitter_node)

const DEFAULT_COLOR = Color("#999999")
const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")
# Te voy a comentar esto por si se te llega a olvidar:
# base_resource es un DialogEventResource relacionado al evento
# que va a modificar. Por ejemplo, en el nodo de TextEvent
# tendrás un base_resource de DialogTextEvent
var base_resource:Resource = null


var _is_focused = false


export(NodePath) var Branch_path:NodePath
export(NodePath) var Name_path:NodePath
export(NodePath) var Preview_path:NodePath
export(NodePath) var Properties_path:NodePath

onready var event_node_branch:Container = get_node(Branch_path) as Container
onready var event_node_name:Container = get_node(Name_path) as Container
onready var event_node_preview:Container = get_node(Preview_path) as Container
onready var event_node_properties:Container = get_node(Properties_path) as Container

func _ready() -> void:
	
	event_node_name.set_drag_forwarding(self)
	
	if not base_resource:
		DialogUtil.Logger.print_debug(self,["There's no resource reference for this event", name])
		return


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
	return data


func expand_properties() -> void:
	after_expand_properties()


func collapse_properties() -> void:
	after_collapse_properties()


func after_expand_properties() -> void:
	pass


func after_collapse_properties() -> void:
	pass
	


func _focused() -> void:
	_is_focused = true
	emit_signal("focus_entered", self)
	expand_properties()


func _unfocused() -> void:
	_is_focused = false
	emit_signal("focus_exited", self)
	
	collapse_properties()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			update()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.scancode == KEY_DELETE and event.pressed and _is_focused:
			accept_event()
			emit_signal("deletion_requested", base_resource)


# deprecated
func _update_node_values() -> void:
	assert(false, "You forgot to override '_update_node_values' method")


# deprecated
func _save_resource() -> void:
	DialogUtil.Logger.print_debug(self, "_save_resource() is deprecated, consider using value_modified() instead")
	resource_value_modified()


# deprecated
func resource_value_modified() -> void:
	emit_signal("event_modified")

func update_event_node_branch() -> void:
	pass


func update_event_node_name() -> void:
	pass


func update_event_node_bar() -> void:
	pass


func update_event_node_values() -> void:
	update_event_node_branch()
	update_event_node_name()
	update_event_node_bar()
