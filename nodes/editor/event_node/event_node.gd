tool
extends VBoxContainer

const Utils = preload("res://addons/event_system_plugin/core/utils.gd")
const SubTimelineNode = preload("res://addons/event_system_plugin/nodes/editor/subtimeline.gd")

class DragData:
	var event:Event
	var related_timeline:Timeline


class EventButton extends HBoxContainer:
	var event:Event
	## The name of [member event]
	var name_label:Label
	## The description of [member event]
	var description_label:Label
	var idx_label:Label
	var button:Button
	
	func set_button_group(button_group:ButtonGroup) -> void:
		button.group = button_group


	func add_node(node:Control) -> void:
		var panel = PanelContainer.new()
		panel.focus_mode = Control.FOCUS_NONE
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.name = "Item %s"%get_child_count()
		panel.add_child(node)
		panel.show_behind_parent = true
		add_child(panel)
		
		var first_item = 1
		var last_item = get_child_count()-1
		var other_items = []
		for child_idx in get_child_count():
			if child_idx in [first_item, last_item]:
				continue
			other_items.append(child_idx)
		
		var child:PanelContainer
		for child_idx in other_items:
			child = get_child(child_idx) as PanelContainer
			if child == null:
				continue
			child.add_stylebox_override("panel", get_stylebox("bg", "EventNode"))
		
		child = get_child(first_item) as PanelContainer
		if child:
			child.add_stylebox_override("panel", get_stylebox("bg_left", "EventNode"))
		if get_child_count() > 1:
			child = get_child(last_item)
			if child:
				child.add_stylebox_override("panel", get_stylebox("bg_right","EventNode"))


	func get_left_node() -> PanelContainer:
		if get_child_count() > 0:
			return get_child(1) as PanelContainer
		return null

	func get_right_node() -> PanelContainer:
		if get_child_count() > 0:
			return get_child(get_child_count()-1) as PanelContainer
		return null


	func update_colors() -> void:
		var event_color:Color = Color.darkslategray
		var left_style:StyleBoxFlat = get_stylebox("bg_left", "EventNode")
		var right_style:StyleBoxFlat = get_stylebox("bg_right", "EventNode")
		var center_style:StyleBoxFlat = get_stylebox("bg", "EventNode")
		
		if event:
			event_color = event.event_color
		
		theme.set_color("event", "EventNode", event_color)
		theme.set_color("default", "EventNode", event_color.darkened(0.25))
		
		if event_color.v < 0.5:
			theme.set_color("font_color", "Label", Color.floralwhite)
			theme.set_color("font_color", "Label", Color.floralwhite)
		else:
			theme.set_color("font_color", "Label", Color.black)
			theme.set_color("font_color", "Label", Color.black)
		
		left_style.bg_color = get_color("event", "EventNode")
		left_style.border_width_right = 1
		left_style.border_color = get_color("default", "EventNode")
		right_style.bg_color = get_color("default", "EventNode")
		center_style.bg_color = get_color("default", "EventNode")


	func update_event_name() -> void:
		var text := "{Event Name}"
		if event:
			text = event.event_name
		name_label.text = text
		

	func update_event_description() -> void:
		var text := "{Event Description}"
		if event:
			text = event.event_preview_string
			text = text.format(Utils.get_property_values_from(event))
		description_label.text = text


	func update_values() -> void:
		update_colors()
		update_event_name()
		update_event_description()
		update()


	func _initialize():
		button = Button.new()
		button.toggle_mode = true
		button.focus_mode = Control.FOCUS_ALL
		button.mouse_filter = Control.MOUSE_FILTER_PASS
		button.connect("mouse_entered", self, "__fake_mouse_enter")
		button.connect("mouse_exited", self, "__fake_mouse_exit")
		button.connect("focus_entered", self, "__fake_focus_enter")
		button.connect("focus_exited", self, "__fake_focus_exit")
		button.connect("toggled", self, "_on_Button_toggled")
		add_child(button)
		
		name_label = Label.new()
		name_label.name = "EventName"
		add_node(name_label)
		
		description_label = Label.new()
		description_label.name = "EventDescription"
		add_node(description_label)
		
		for node in [name_label, description_label]:
			node.mouse_filter = Control.MOUSE_FILTER_IGNORE
			node.focus_mode = Control.FOCUS_NONE
			node.size_flags_horizontal = SIZE_EXPAND_FILL
			node.size_flags_vertical = SIZE_EXPAND_FILL
			node.align = Label.ALIGN_LEFT
			node.valign = Label.VALIGN_CENTER
		
		for node_idx in [1,2]:
			var node:PanelContainer = get_child(node_idx) as PanelContainer
			if not node: continue
			if node_idx == 1:
				node.size_flags_stretch_ratio = 2
			else:
				node.size_flags_stretch_ratio = 8
			node.show_behind_parent = true
			node.size_flags_horizontal = SIZE_EXPAND_FILL
			node.size_flags_vertical = SIZE_EXPAND_FILL
		
		idx_label = Label.new()
		add_node(idx_label)
		idx_label.hide()


	func __fake_draw() -> void:
		var outline_stylebox:StyleBoxFlat = get_stylebox("outline", "EventNode")
		draw_style_box(outline_stylebox, Rect2(Vector2.ZERO, rect_size))


	func __fake_focus_enter() -> void:
		var outline_stylebox:StyleBoxFlat = get_stylebox("outline", "EventNode")
		outline_stylebox.set_border_width_all(4)


	func __fake_focus_exit() -> void:
		var outline_stylebox:StyleBoxFlat = get_stylebox("outline", "EventNode")
		outline_stylebox.set_border_width_all(2)


	func __fake_mouse_enter() -> void:
		for style in [get_stylebox("bg","EventNode"), get_stylebox("bg_right","EventNode")]:
			style.bg_color = get_color("event", "EventNode")


	func __fake_mouse_exit() -> void:
		for style in [get_stylebox("bg", "EventNode"), get_stylebox("bg_right", "EventNode")]:
			style.bg_color = get_color("default", "EventNode")
	
	
	func _on_Button_toggled(button_pressed:bool) -> void:
		var outline_stylebox:StyleBoxFlat = get_stylebox("outline", "EventNode")
		var color:Color
		
		outline_stylebox.set_border_width_all(2)
		
		if button_pressed:
			color = get_color("hover", "EventNode")
		else:
			color = get_color("outline", "EventNode")
		
		outline_stylebox.border_color = color


	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_DRAW:
				__fake_draw()
			NOTIFICATION_SORT_CHILDREN:
				fit_child_in_rect(button, get_rect())
			NOTIFICATION_READY:
				button.set_meta("event_node", get_parent())


	func _init() -> void:
		theme = load("res://addons/event_system_plugin/assets/themes/event_node/event_node.tres") as Theme
		theme = theme.duplicate(true)
		rect_clip_content = true
		focus_mode = Control.FOCUS_NONE
		mouse_filter = Control.MOUSE_FILTER_PASS
		name = "EventButton"
		_initialize()


signal subevent_added(event_node)
signal subtimeline_added(timelinedisplayer_node)

var event_button:EventButton
var subtimeline_container:SubTimelineNode

## Event related to this node
var event:Event setget set_event

## Timeline that contains this event. Used as editor hint
var timeline:Timeline
var idx:int setget set_idx

## Subevents nodes
var subevents := {}
## Subtimelines timelines
var subtimelines := {}

func update_values() -> void:
	event_button.update_values()
	
	subtimeline_container.visible = !subtimelines.empty()
	
	if has_method("_update_values"):
		call("_update_values")


func set_event(_event) -> void:
	if event and event.is_connected("changed",self,"update_values"):
		event.disconnect("changed",self,"update_values")
	
	event = _event
	
	if event != null:
		if not event.is_connected("changed",self,"update_values"):
			event.connect("changed",self,"update_values")
		name = event.event_name
		if is_instance_valid(event_button):
			event_button.set("event", event)


func set_idx(value:int) -> void:
	idx = value
	event_button.idx_label.text = str(idx)


func add_subtimeline(subtimeline) -> void:
	if subtimelines.has(subtimeline):
		emit_signal("subtimeline_added", subtimelines[subtimeline])
		return
	
	var node = subtimeline_container.add_timeline_and_get_node(subtimeline)
	subtimelines[subtimeline] = node
	subtimeline_container.show()
	emit_signal("subtimeline_added", node)


func add_subevent(event) -> void:
	if subevents.has(event):
		emit_signal("subevent_added", subevents[event])
		return
	
	var event_node:Control = null
	event_node = event.get("custom_event_node")
	if event_node == null:
		# Cyclic recursions not allowed, that means I can't write EventNode
		var event_node_script:Script = load("res://addons/event_system_plugin/nodes/editor/event_node/event_node.gd") as Script
		event_node = event_node_script.new()
	
	subevents[event] = event_node
	
	event_node.set("event", event)
	emit_signal("subevent_added", event_node)
	add_child(event_node)
	event_node.call_deferred("update_values")

func set_button_group(button_group:ButtonGroup) -> void:
	event_button.set_button_group(button_group)


func _init():
	event_button = EventButton.new()
	add_child(event_button)
	
	subtimeline_container = SubTimelineNode.new()
	add_child(subtimeline_container)
	
	subtimelines = {}
	subevents = {}
