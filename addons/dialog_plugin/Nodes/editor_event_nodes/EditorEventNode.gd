tool
class_name DialogEditorEventNode
extends Control

signal delelete_item_requested(item)
signal save_item_requested(item)
signal item_selected(item)
signal item_dragged(item, node_idx, to_idx)

const DEFAULT_COLOR = Color("#202531")
const SELECTED_COLOR = Color("#353f57")
const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")

var DialogUtil := load("res://addons/dialog_plugin/Core/DialogUtil.gd")
var base_resource:Resource = null
var idx:int = 0 setget _set_idx
var drag_position

var _p_idx
var _n_idx
var _prev_node
var _next_node

export(NodePath) var IconNode_path:NodePath
export(NodePath) var TopContent_path:NodePath
export(NodePath) var CenterContent_path:NodePath
export(NodePath) var BottomContent_path:NodePath
export(NodePath) var IndexLbl_path:NodePath
export(NodePath) var MenuBtn_path:NodePath

onready var top_content_node:PanelContainer = get_node_or_null(TopContent_path)
onready var center_content_node:PanelContainer = get_node_or_null(CenterContent_path)
onready var bottom_content_node:PanelContainer = get_node_or_null(BottomContent_path)
onready var icon_node:TextureRect = get_node_or_null(IconNode_path)
onready var index_label_node = get_node_or_null(IndexLbl_path)
onready var menu_button_node:MenuButton = get_node(MenuBtn_path)

func _ready() -> void:
	
	if not base_resource:
		DialogUtil.Logger.print(self,["There's no resource reference for this event", name])
		return
	
	if not (base_resource as Resource).is_connected("changed", self, "_on_resource_change"):
		base_resource.connect("changed", self, "_on_resource_change")
	
	var menu_button_popup_node:PopupMenu = menu_button_node.get_popup()
	var _err = menu_button_popup_node.connect("id_pressed", self, "_on_MenuButtonPopup_id_pressed")
	assert(_err == OK)


func _set_idx(value):
	if index_label_node:
		idx = value
		index_label_node.text = str(value)


func _update_node_values() -> void:
	# If you can see this, you didn't override this method
	assert(false)


func _save_resource() -> void:
	emit_signal("save_item_requested", base_resource)


func _on_resource_change() -> void:
	_update_node_values()


func _on_MenuButtonPopup_id_pressed(id:int) -> void:
	if id == 0:
		emit_signal("delelete_item_requested", base_resource)


func _notification(what):
	match what:
		NOTIFICATION_FOCUS_ENTER:
			var style:StyleBoxFlat = get_stylebox("panel")
			style.bg_color = SELECTED_COLOR
		NOTIFICATION_FOCUS_EXIT:
			var style:StyleBoxFlat = get_stylebox("panel")
			style.bg_color = DEFAULT_COLOR


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
		index_label_node.text = "no_index"
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
