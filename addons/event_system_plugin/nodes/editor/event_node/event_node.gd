tool
extends Control

const Utils = preload("res://addons/event_system_plugin/core/utils.gd")

export(NodePath) var DrawNodePath:NodePath

export(NodePath) var NameContainerPath:NodePath
export(NodePath) var EventIconPath:NodePath
export(NodePath) var EventNamePath:NodePath

export(NodePath) var DescContainerPath:NodePath
export(NodePath) var EventDescPath:NodePath
export(NodePath) var EventIdxPath:NodePath

var event:Event = null
var event_index:int = -1

onready var _draw_node:Control = get_node(DrawNodePath) as Control

onready var _name_container:Control = get_node(NameContainerPath) as Control
onready var _icon_node:TextureRect = get_node(EventIconPath) as TextureRect
onready var _name_node:Label = get_node(EventNamePath) as Label

onready var _desc_container_node:PanelContainer = get_node(DescContainerPath) as PanelContainer
onready var _description_node:Label = get_node(EventDescPath) as Label
onready var _index_node:Label = get_node(EventIdxPath) as Label


func _fake_ready() -> void:
	if not event:
		push_error("No event resource")
		return
	
	if not event.is_connected("changed", self, "_update_values"):
		event.connect("changed", self, "_update_values")
	
	get_tree().root.connect("gui_focus_changed", self, "_on_global_focus_changed")
	
	_name_container.set_drag_forwarding(self)
	
	_update_values()


func _update_values() -> void:
	_update_event_colors()
	_update_event_name()
	_update_event_description()
	_update_event_index()
	_update_event_icon()
	update()


func _update_event_colors() -> void:
	add_color_override("event", event.event_color)
	add_color_override("default", event.event_color.darkened(0.25))
	var name_stylebox:StyleBoxFlat = _name_container.get_stylebox("panel") as StyleBoxFlat
	var desc_stylebox:StyleBoxFlat = _desc_container_node.get_stylebox("panel") as StyleBoxFlat
	name_stylebox.bg_color = get_color("event")
	desc_stylebox.bg_color = get_color("default")
	desc_stylebox.border_color = get_color("outline")
	
	if event.event_color.v < 0.5:
		theme.set_color("font_color", "Label", Color.floralwhite)
		theme.set_color("font_color", "Label", Color.floralwhite)
	else:
		theme.set_color("font_color", "Label", Color.black)
		theme.set_color("font_color", "Label", Color.black)


func _update_event_name() -> void:
	_name_node.text = event.event_name


func _update_event_description() -> void:
	var text:String = event.event_preview_string
	text = text.format(Utils.get_property_values_from(event))
	_description_node.text = text


func _update_event_index() -> void:
	_index_node.text = str(event_index)


func _update_event_icon() -> void:
	_icon_node.texture = event.event_icon


func _draw() -> void:
	if not event:
		return
	_draw_main_branch()


func _draw_main_branch() -> void:
	_draw_top_line()
	
	if not event.get("branch_disabled"):
		_draw_bottom_line()
	
	_draw_connection_line()
	
	_draw_line_center()


func _draw_top_line() -> void:
	var vl_start_point = Vector2(_draw_node.rect_size.x/2, 0)
	var vl_end_point = Vector2(_draw_node.rect_size.x/2, _name_container.rect_size.y/2)
	
	draw_line(vl_start_point, vl_end_point, Color.black, 2)


func _draw_bottom_line() -> void:
	var vl_start_point = _draw_node.rect_size/2
	var vl_end_point = Vector2(_draw_node.rect_size.x/2, rect_size.y)
	
	if event.get("continue_at_end_ignore"):
		draw_line(vl_start_point, vl_end_point, Color.black, 2)
		return
	
	if event.continue_at_end:
		draw_line(vl_start_point, vl_end_point, Color.black, 2)
		_draw_arrow()
	else:
		_draw_double_line()


func _draw_arrow() -> void:
	var vl_start_point = Vector2(_draw_node.rect_size.x/2, 0)
	var vl_end_point = Vector2(_draw_node.rect_size.x/2, rect_size.y)
	
	var triangle:PoolVector2Array = PoolVector2Array(
		[
			Vector2(vl_end_point.x-4, rect_size.y-4),
			Vector2(vl_end_point.x+4, rect_size.y-4),
			vl_end_point
			]
		)
	
	var points = triangle
	var colors = PoolColorArray()
	for point in points:
		colors.append(Color.black)
	draw_polygon(points, colors, PoolVector2Array(), null, null, true)


func _draw_double_line() -> void:
	# I'm gonna have nightmares with custom draws for sure
	var vl_start_point = _draw_node.rect_size/2
	var vl_end_point = Vector2(_draw_node.rect_size.x/2, rect_size.y)
	
	var line_separation = Vector2(0,2.5)
	var middle_point = Vector2(vl_start_point.x, (vl_end_point.y + vl_start_point.y)/2)
	
	var top_line_start = vl_start_point
	var top_line_end = middle_point-line_separation
	
	var bot_line_start = middle_point + line_separation
	var bot_line_end = vl_end_point
	
	draw_line(top_line_start, top_line_end, Color.black, 2)
	draw_line(bot_line_start, bot_line_end, Color.black, 2)
	
	draw_line(top_line_end+Vector2(-4,0), top_line_end+Vector2(4,0), Color.black, 2)
	draw_line(bot_line_start+Vector2(-4,0), bot_line_start+Vector2(4,0), Color.black, 2)



func _draw_connection_line() -> void:
	var hl_start_point = (_name_container.rect_size/2)+_name_container.rect_position
	var _pos_hint = Vector2(_draw_node.rect_size.x/2, hl_start_point.y)
	var hl_end_point = _pos_hint+_draw_node.rect_position
	
	draw_line(hl_start_point, hl_end_point, Color.black, 2)


func _draw_line_center() -> void:
	var _pos_hint = Vector2(_draw_node.rect_size.x/2, _name_container.rect_size.y/2)
	var pivot = _pos_hint+_draw_node.rect_position
	
	draw_arc(pivot, 5, 0, 2*PI, 16, Color.black, 1, true)
	draw_circle(pivot, 2, get_color("event"))


func get_drag_data_fw(_position: Vector2, _of_node:Control):
	var node = self.duplicate(0)
	node.rect_size = Vector2.ZERO
	set_drag_preview(node)
	return event


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_FOCUS_ENTER:
			_on_focus_enter()
		
		NOTIFICATION_FOCUS_EXIT:
			_on_focus_exit()
		
		NOTIFICATION_MOUSE_ENTER:
			_on_mouse_enter()
		
		NOTIFICATION_MOUSE_EXIT:
			_on_mouse_exit()


func _on_focus_enter() -> void:
	var desc_stylebox:StyleBoxFlat = _desc_container_node.get_stylebox("panel") as StyleBoxFlat
	var name_stylebox:StyleBoxFlat = _name_container.get_stylebox("panel") as StyleBoxFlat
	desc_stylebox.border_color = get_color("hover")
	name_stylebox.border_color = get_color("hover")
	desc_stylebox.shadow_size = 2
	name_stylebox.shadow_size = 2


func _on_focus_exit(force:bool=false) -> void:
	
	var focus_owner = get_focus_owner()
	if not (is_instance_valid(focus_owner) or force):
		return
	
	if not(focus_owner is Container):
		return
		
	var desc_stylebox:StyleBoxFlat = _desc_container_node.get_stylebox("panel") as StyleBoxFlat
	var name_stylebox:StyleBoxFlat = _name_container.get_stylebox("panel") as StyleBoxFlat
	desc_stylebox.border_color = get_color("outline")
	name_stylebox.border_color = get_color("outline")
	desc_stylebox.shadow_size = 0
	name_stylebox.shadow_size = 0


func _on_mouse_enter() -> void:
	var desc_stylebox:StyleBoxFlat = _desc_container_node.get_stylebox("panel") as StyleBoxFlat
	desc_stylebox.bg_color = get_color("event")


func _on_mouse_exit() -> void:
	var desc_stylebox:StyleBoxFlat = _desc_container_node.get_stylebox("panel") as StyleBoxFlat
	desc_stylebox.bg_color = get_color("default")


func _on_global_focus_changed(node) -> void:
	if node != self:
		_on_focus_exit(true)
