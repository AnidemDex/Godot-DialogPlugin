tool
extends VBoxContainer

class EventMenu extends PopupMenu:
	enum ItemType {TITLE,EDIT,DUPLICATE,REMOVE}
	
	var used_event:Resource setget set_event
	var shortcuts = load("res://addons/event_system_plugin/core/shortcuts.gd")
	
	func _enter_tree() -> void:
		var remove_shortcut = shortcuts.get_shortcut("remove")
		var duplicate_shortcut = shortcuts.get_shortcut("duplicate")
		
		add_separator("{EventName}")
		
		add_icon_item(get_icon("Edit", "EditorIcons"), "Edit")
		
		add_shortcut(duplicate_shortcut)
		set_item_icon(ItemType.DUPLICATE, get_icon("ActionCopy", "EditorIcons"))
		set_item_text(ItemType.DUPLICATE, "Duplicate")
		
		add_shortcut(remove_shortcut)
		set_item_icon(ItemType.REMOVE, get_icon("Remove", "EditorIcons"))
		set_item_text(ItemType.REMOVE, "Remove")
	
	
	func set_title(title:String) -> void:
		set_item_text(0, title)
	
	
	func set_event(event:Resource) -> void:
		used_event = event
		var event_name:String = "{EventName}"
		if used_event:
			event_name = str(used_event.get("event_name"))
		set_title(event_name)


const TimelineDisplayer = preload("res://addons/event_system_plugin/nodes/editor/timeline_displayer.gd")
const EventNode = preload("res://addons/event_system_plugin/nodes/editor/event_node/event_node.gd")
const CategoryManager = preload("res://addons/event_system_plugin/nodes/editor/category_manager.gd")

signal event_selected(event)

var shortcuts = load("res://addons/event_system_plugin/core/shortcuts.gd")

var timeline_displayer:TimelineDisplayer
var last_selected_event_node:EventNode

var _sc:ScrollContainer
var _event_menu:EventMenu
var _edited_sequence:Resource
var _info_label:Label
var _category_manager:CategoryManager

var __undo_redo:UndoRedo # Do not use thid directly, get its reference with _get_undo_redo
var __group:ButtonGroup

func set_undo_redo(value:UndoRedo) -> void:
	# Sets UndoRedo, but this object can leave leaked isntances so make sure to set it
	# with an external reference (aka Editor's UndoRedo).
	# To internal use of UndoRedo use _get_undo_redo instead.
	__undo_redo = value


func edit_timeline(sequence) -> void:
	_disconnect_edited_sequence_signals()
	
	_edited_sequence = sequence
	timeline_displayer.remove_all_displayed_events()
	if sequence:
		timeline_displayer.load_timeline(sequence)
	update_info_label()
	
	_connect_edited_sequence_signals()


func reload() -> void:
	timeline_displayer.call_deferred("load_timeline", _edited_sequence)
	update_info_label()


func update_info_label() -> void:
	var text := "Path: {0}|{1}"
	var args = ["[No resource]", "Open a timeline to start editing"]
	
	if _edited_sequence:
		args[0] = _edited_sequence.resource_path
		args[1] = _edited_sequence.resource_name
	
	_info_label.text = text.format(args)


func remove_event(event:Event, from_resource:Resource) -> void:
	if event == null or from_resource == null:
		return
	
	var _UndoRedo:UndoRedo = _get_undo_redo()
	
	var event_idx:int = from_resource.get_events().find(event)
	_UndoRedo.create_action("Remove event from timeline")
	_UndoRedo.add_do_method(from_resource, "erase_event", event)
	_UndoRedo.add_undo_method(from_resource, "add_event", event, event_idx)
	_UndoRedo.commit_action()


func add_event(event:Event, at_position:int=-1, from_resource:Resource=_edited_sequence) -> void:
	if not from_resource:
		return
	
	var _UndoRedo:UndoRedo = _get_undo_redo()
	_UndoRedo.create_action("Add event %s"%event.event_name)
	_UndoRedo.add_do_method(from_resource, "add_event", event, at_position)
	_UndoRedo.add_undo_method(from_resource, "erase_event", event)
	_UndoRedo.commit_action()

func get_drag_data_fw(position, node):
	if node is EventNode:
		var event = node.get("event")
		var timeline = node.get("timeline")
		remove_event(event, timeline)
		if not event:
			return null
			
		var _node = node.event_button.duplicate(0)
		
		_node.rect_size = Vector2.ZERO
		set_drag_preview(_node)
		var data = EventNode.DragData.new()
		data.event = event
		return data


var _separator_node:EventNode.EventButton
var _idx_hint:int = -1
var _last_node:Node
func can_drop_data_fw(position: Vector2, data, node:Control) -> bool:
	var event_data
	
	if typeof(data) in [TYPE_OBJECT, TYPE_DICTIONARY]:
		event_data = data.get("event")
	else:
		return false
	
	if is_instance_valid(_separator_node):
		if _separator_node.is_inside_tree():
			var separator_parent:Node = _separator_node.get_parent()
			
			if node is TimelineDisplayer and node != separator_parent:
				separator_parent.remove_child(_separator_node)
				node.add_child(_separator_node)
		else:
			if node is TimelineDisplayer:
				node.add_child(_separator_node)
		
		if node is EventNode and node != _separator_node:
			var node_rect:Rect2 = node.event_button.get_rect()
			if position.y > node_rect.size.y/2:
				_idx_hint = node.idx+1
			else:
				_idx_hint = node.idx
		
		if node is TimelineDisplayer:
			if _last_node == node:
				_idx_hint = node.get_child_count()-1
			_idx_hint = clamp(_idx_hint, 0, node.get_child_count())
			node.move_child(_separator_node, _idx_hint)
		
		_separator_node.set("event", event_data)
		_separator_node.update_values()
	else:
		_generate_separator_node()
	
	_last_node = node
	return node is TimelineDisplayer and event_data is Event


func drop_data_fw(position: Vector2, data, node) -> void:
	var event_data = data.get("event")
	_idx_hint = _separator_node.get_index()
	add_event(event_data, _idx_hint, node.last_used_timeline)
	_idx_hint = -1


func _generate_separator_node() -> void:
	_separator_node = EventNode.EventButton.new()
	_separator_node.propagate_call("set", ["focus_mode", Control.FOCUS_NONE])
	_separator_node.propagate_call("set", ["mouse_filter", Control.MOUSE_FILTER_PASS])
	_separator_node.modulate.a = 0.5
	_separator_node.modulate = _separator_node.modulate.darkened(0.2)
	connect("tree_exited", _separator_node, "free")
	_separator_node.set_drag_forwarding(self)


func _get_undo_redo() -> UndoRedo:
	if not is_instance_valid(__undo_redo):
		__undo_redo = UndoRedo.new()
		connect("tree_exiting", __undo_redo, "free")
	return __undo_redo


func _disconnect_edited_sequence_signals() -> void:
	if _edited_sequence:
		if _edited_sequence.is_connected("changed", self, "reload"):
			_edited_sequence.disconnect("changed",self,"reload")


func _connect_edited_sequence_signals() -> void:
	if _edited_sequence:
		if not _edited_sequence.is_connected("changed",self,"reload"):
			_edited_sequence.connect("changed",self,"reload")

func _input(event: InputEvent) -> void:
	var event_node = last_selected_event_node
	var focus_owner = get_focus_owner()
	
	if not is_instance_valid(event_node):
		return
	
	if is_instance_valid(focus_owner):
		if not event_node.is_a_parent_of(focus_owner):
			return
	
	var _event = last_selected_event_node.get("event")
	
	var duplicate_shortcut = shortcuts.get_shortcut("duplicate")
	if event.shortcut_match(duplicate_shortcut.shortcut):
		if _event and event.is_pressed():
			timeline_displayer.remove_all_displayed_events()
			var position:int = _edited_sequence.get_events().find(_event)
			add_event(_event.duplicate(), position+1, event_node.timeline)
		event_node.accept_event()
	
	var delete_shortcut = shortcuts.get_shortcut("delete")
	if event.shortcut_match(delete_shortcut.shortcut):
		if _event:
			timeline_displayer.remove_all_displayed_events()
			remove_event(_event, event_node.timeline)
		event_node.accept_event()


func _on_EventButton_selected(button) -> void:
	last_selected_event_node = button.get_meta("event_node")
	emit_signal("event_selected", last_selected_event_node.event)


func _on_EventNode_gui_input(event: InputEvent, event_node:EventNode) -> void:
	var _event:Event = event_node.event
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			if _event:
				_event_menu.used_event = _event
				_event_menu.popup(Rect2(get_global_mouse_position()+Vector2(1,1), _event_menu.rect_size))
			event_node.accept_event()


func _on_EventNode_subtimeline_added(subtimeline_displayer:Control, event_node:Control) -> void:
	if not subtimeline_displayer.is_connected("event_node_added", self, "_on_TimelineDisplayer_event_node_added"):
		subtimeline_displayer.connect("event_node_added", self, "_on_TimelineDisplayer_event_node_added")
	
	if subtimeline_displayer.last_used_timeline == _edited_sequence:
		subtimeline_displayer.free()
		(event_node.subtimelines as Dictionary).erase(_edited_sequence)
		var new_timeline = Timeline.new()
		var goto = EventComment.new()
		goto.text = "This subtimeline is the same as the main timeline, that's why it was replaced by this event"
		new_timeline.add_event(goto)
		event_node.call_deferred("add_subtimeline",new_timeline)
		return
	subtimeline_displayer.set_drag_forwarding(self)


func _on_EventNode_subevent_added(event_node:Control) -> void:
	if not event_node.is_connected("subtimeline_added", self, "_on_EventNode_subtimeline_added"):
		event_node.connect("subtimeline_added", self, "_on_EventNode_subtimeline_added", [event_node])


func _on_TimelineDisplayer_event_node_added(event_node:Control) -> void:
	if not event_node.is_connected("gui_input", self, "_on_EventNode_gui_input"):
		event_node.connect("gui_input", self, "_on_EventNode_gui_input", [event_node])
	
	if not event_node.is_connected("subtimeline_added", self, "_on_EventNode_subtimeline_added"):
		event_node.connect("subtimeline_added", self, "_on_EventNode_subtimeline_added", [event_node])
	
	if not event_node.is_connected("subevent_added", self, "_on_EventNode_subevent_added"):
		event_node.connect("subevent_added", self, "_on_EventNode_subevent_added")
	
	event_node.set_drag_forwarding(self)
	event_node.set_button_group(__group)

func _on_EventMenu_index_pressed(idx:int) -> void:
	var _used_event:Event = _event_menu.used_event as Event
	
	if _used_event == null:
		return
	
	# I'm not gonna lost my time recycling nodes tbh
	timeline_displayer.remove_all_displayed_events()
	
	match idx:
		EventMenu.ItemType.EDIT:
			emit_signal("event_selected", _used_event)
			_edited_sequence.emit_changed()
		
		EventMenu.ItemType.DUPLICATE:
			var position:int = _edited_sequence.get_events().find(_used_event)
			add_event(_used_event.duplicate(), position+1)
			
		EventMenu.ItemType.REMOVE:
			remove_event(_used_event, _edited_sequence)


func _on_CategoryManager_button_pressed(button:Button, event_script:Script) -> void:
	var idx := -1
	var timeline := _edited_sequence
	if is_instance_valid(last_selected_event_node):
		idx = last_selected_event_node.idx+1
		timeline = last_selected_event_node.timeline
	if not timeline:
		timeline = _edited_sequence
		idx = -1
	add_event(event_script.new(), idx, timeline)


func _init() -> void:
	__group = ButtonGroup.new()
	__group.connect("pressed", self, "_on_EventButton_selected")
	add_constant_override("separation", 2)
	theme = load("res://addons/event_system_plugin/assets/themes/timeline_editor.tres") as Theme
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	_info_label = Label.new()
	_info_label.name = "Info Label"
	add_child(_info_label)
	
	_category_manager = CategoryManager.new()
	_category_manager.connect("toolbar_button_pressed", self, "_on_CategoryManager_button_pressed")
	add_child(_category_manager)
	
	_sc = ScrollContainer.new()
	_sc.follow_focus = true
	_sc.size_flags_horizontal = SIZE_EXPAND_FILL
	_sc.size_flags_vertical = SIZE_EXPAND_FILL
	_sc.mouse_filter = Control.MOUSE_FILTER_PASS
	_sc.rect_min_size = Vector2(128, 254)
	
	var _dummy_panel := PanelContainer.new()
	_dummy_panel.size_flags_horizontal = SIZE_EXPAND_FILL
	_dummy_panel.size_flags_vertical = SIZE_EXPAND_FILL
	_dummy_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_dummy_panel.focus_mode = Control.FOCUS_CLICK
	_sc.add_child(_dummy_panel)
	
	var timeline_drawer = load("res://addons/event_system_plugin/nodes/editor/timeline_drawer.gd").new()
	timeline_drawer.focus_mode = Control.FOCUS_NONE
	timeline_drawer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_dummy_panel.add_child(timeline_drawer)
	
	timeline_displayer = TimelineDisplayer.new()
	timeline_displayer.connect("event_node_added", self, "_on_TimelineDisplayer_event_node_added")
	_dummy_panel.add_child(timeline_displayer)
	timeline_drawer.timeline_displayer = timeline_displayer
	timeline_displayer.set_drag_forwarding(self)
	add_child(_sc)
	
	_event_menu = EventMenu.new()
	_event_menu.connect("index_pressed", self, "_on_EventMenu_index_pressed")
	_event_menu.connect("hide", _event_menu, "set", ["used_event", null])
	add_child(_event_menu)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			_sc.add_stylebox_override("bg",get_stylebox("bg", "Tree"))
		NOTIFICATION_DRAG_END:
			if is_instance_valid(_separator_node):
				_separator_node.queue_free()
		NOTIFICATION_THEME_CHANGED:
			get_stylebox("panel", "PanelContainer").content_margin_left = get_constant("identation", "PanelContainer")
