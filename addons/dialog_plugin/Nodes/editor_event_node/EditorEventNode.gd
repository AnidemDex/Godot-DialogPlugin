tool
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
var base_resource:Resource

var event_index:int = -1


export(NodePath) var Branch_path:NodePath
export(NodePath) var Name_path:NodePath
export(NodePath) var Info_path:NodePath

onready var event_node_branch:Container = get_node(Branch_path) as Container
onready var event_node_name:Container = get_node(Name_path) as Container
onready var event_node_info:Container = get_node(Info_path) as Container

func _ready() -> void:
	
	event_node_name.set_drag_forwarding(self)
	
	if not base_resource:
		DialogUtil.Logger.print_debug(self,["There's no resource reference for this event", name])
		return


func _clips_input() -> bool:
	return true


func get_drag_data_fw(position: Vector2, from_control:Control):
	if not base_resource:
		return
	var data = base_resource
	var drag_preview_node:Control = self.duplicate()
	drag_preview_node.set("base_resource", base_resource)
	drag_preview_node.set("event_index", -1)
	
	drag_preview_node.size_flags_horizontal = Control.SIZE_FILL
	drag_preview_node.size_flags_vertical = Control.SIZE_FILL
	drag_preview_node.anchor_right = 0
	drag_preview_node.anchor_bottom = 0
	drag_preview_node.rect_size = Vector2(50,50)
	drag_preview_node.rect_min_size = Vector2(50,50)
	set_drag_preview(drag_preview_node)
	drag_preview_node.call("update_event_node_values")
	emit_signal("deletion_requested", base_resource)
	return data

func is_focused() -> bool:
	var focus_owner = get_focus_owner()
	return is_instance_valid(focus_owner) and is_a_parent_of(focus_owner)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.scancode == KEY_DELETE and event.pressed and is_focused():
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
	if not base_resource.is_connected("changed", event_node_branch, "update_node_values"):
		base_resource.connect("changed", event_node_branch, "update_node_values")
	event_node_branch.set("base_resource", base_resource)
	event_node_branch.call("update_node_values")


func update_event_node_name() -> void:
	event_node_name.set("base_resource", base_resource)
	event_node_name.call("update_node_values")


func update_event_node_bar() -> void:
	event_node_info.set("base_resource", base_resource)
	event_node_info.set("event_index", event_index)
	event_node_info.call("update_node_values")


func update_event_node_values() -> void:
	update_event_node_branch()
	update_event_node_name()
	update_event_node_bar()
