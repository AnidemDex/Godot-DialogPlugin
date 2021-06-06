tool
class_name DialogEditorEventNode
extends Control

signal delelete_item_requested(item)
signal save_item_requested(item)
signal item_selected(item)
signal item_dragged(item, node_idx, to_idx)
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
var drag_position

var _p_idx
var _n_idx
var _prev_node
var _next_node

var _stylebox:StyleBoxFlat

export(Color) var event_color = Color("3c3d5e") setget _set_event_color

export(NodePath) var IconNode_path:NodePath
export(NodePath) var TopContent_path:NodePath
export(NodePath) var PropertiesContainer_path:NodePath
export(NodePath) var IndexLbl_path:NodePath
export(NodePath) var SkipBtn_path:NodePath



onready var top_content_node:PanelContainer = get_node(TopContent_path) as PanelContainer
onready var properties_content_node:PanelContainer = get_node(PropertiesContainer_path) as PanelContainer
onready var icon_node:TextureRect = get_node(IconNode_path) as TextureRect
onready var index_label_node = get_node(IndexLbl_path)
onready var skip_button_node:CheckBox = get_node(SkipBtn_path) as CheckBox

func _ready() -> void:
	
	if not base_resource:
		DialogUtil.Logger.print(self,["There's no resource reference for this event", name])
		return
	
	if not base_resource.is_connected("changed", self, "_on_resource_change"):
		base_resource.connect("changed", self, "_on_resource_change")
	
	skip_button_node.pressed = base_resource.skip


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


var _is_focused = false
func _focused() -> void:
	var _top_container_node = top_content_node.get_node("HContainer")
	if not _top_container_node:
		return
	
	_stylebox = top_content_node.get_stylebox("panel") as StyleBoxFlat
	_stylebox.bg_color = event_color
	_stylebox = properties_content_node.get_stylebox("panel") as StyleBoxFlat
	_stylebox.bg_color = event_color
	
	_top_container_node.toggle(true)
	_is_focused = true


func _unfocused() -> void:
	var _top_container_node = top_content_node.get_node("HContainer")
	if not _top_container_node:
		return
	
	_top_container_node.toggle(false)
	_stylebox = top_content_node.get_stylebox("panel") as StyleBoxFlat
	_stylebox.bg_color = DEFAULT_COLOR
	_stylebox = properties_content_node.get_stylebox("panel") as StyleBoxFlat
	_stylebox.bg_color = DEFAULT_COLOR
	
	_is_focused = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			update()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.scancode == KEY_DELETE and event.pressed and _is_focused:
			accept_event()
			emit_signal("delelete_item_requested", base_resource)


func _set_idx(value):
	if index_label_node:
		idx = value
		index_label_node.text = str(value)


func _update_node_values() -> void:
	# If you can see this, you didn't override this method
	assert(false)


func _save_resource() -> void:
	emit_signal("save_item_requested", base_resource)


func _set_event_color(value:Color) -> void:
	event_color = value
	# FIXME: Why are you using absolute node path here?
	if $HContainer/HContainer/NameMargin/EventName:
		$HContainer/HContainer/NameMargin/EventName.get_stylebox("panel").bg_color = event_color
	property_list_changed_notify()


func _on_resource_change() -> void:
	_update_node_values()


var last_drag
var start_drag
var new_idx = 0

func _on_Top_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			emit_signal("item_selected", base_resource)
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
			last_drag = null
			start_drag = null
		
		if event.button_index == BUTTON_LEFT and not event.pressed:
			emit_signal("item_dragged", base_resource, idx, new_idx, true)
	
	if event is InputEventMouseMotion and drag_position:
		# Hey, since you're here, take care. This is a dangerous zone
		# that i managed to do after many no-sleep hours.
		
		# Stay fresh!
		
		# Drag behaviour
		index_label_node.text = "???"
		var _drag = get_global_mouse_position().y - drag_position.y
		if not start_drag:
			start_drag = _drag
			last_drag = _drag
		
		var _distance = last_drag-start_drag
		
		var _parent = get_parent()
		if _parent:
			if not _prev_node:
				_p_idx = clamp(idx-1, 0, _parent.get_child_count()-1)
				_prev_node = _parent.get_child(_p_idx)
			if not _next_node:
				_n_idx = clamp(idx+1, 0, _parent.get_child_count()-1)
				_next_node = _parent.get_child(_n_idx)
			
			# Required distance before moving
			var _up_distance = 0
			var _down_distance = 0
			
			if _next_node and _next_node != self:
					_up_distance = _next_node.rect_size.y
	
			if _prev_node and _prev_node != self:
				_down_distance = -_prev_node.rect_size.y
			
			if _down_distance == 0:
				_down_distance = -_up_distance if _up_distance != 0 else 0
			if _up_distance == 0:
				_up_distance = abs(_down_distance) if _down_distance != 0 else 0
			
			
			if _distance >= _up_distance and _up_distance != 0:
				start_drag = last_drag
				new_idx += 1
			
			if _distance <= _down_distance and _down_distance != 0:
				start_drag = last_drag
				new_idx -= 1
			
			# This print here saved my life many times. 
			#printt(_distance,last_drag, new_idx, idx, start_drag, _up_distance, _down_distance, _prev_node == self,_next_node == self)
			emit_signal("item_dragged", base_resource, idx, new_idx)
			rect_global_position.y = _drag
			last_drag = _drag


func _on_SkipButton_toggled(button_pressed: bool) -> void:
	if base_resource:
		base_resource.skip = button_pressed
		_save_resource()
