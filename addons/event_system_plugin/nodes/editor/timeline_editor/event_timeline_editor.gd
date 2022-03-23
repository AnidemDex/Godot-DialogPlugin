tool
extends Container

signal event_selected(event)

const _CategoryManager = preload("res://addons/event_system_plugin/nodes/editor/category_manager/category_manager.gd")
const _TimelineDisplayer = preload("res://addons/event_system_plugin/nodes/editor/timeline_editor/timeline_displayer.gd")

export(NodePath) var ResourceNamePath:NodePath
export(NodePath) var CategoryManagerPath:NodePath
export(NodePath) var HistoryMenuPath:NodePath

export(NodePath) var EventContainerPath:NodePath

var _UndoRedo:UndoRedo
var _PluginScript:EditorPlugin
var _edited_resource:Timeline
var _registered_events:Resource = load("res://addons/event_system_plugin/resources/registered_events/registered_events.tres")
var _separator_node:Control
var _last_focused_event_node:Control

var _history_popup_menu:PopupMenu
var _history:Array = []

onready var _name_node:Label = get_node(ResourceNamePath) as Label
onready var _category_manager:_CategoryManager = get_node(CategoryManagerPath) as _CategoryManager
onready var _timeline_displayer:_TimelineDisplayer = get_node(EventContainerPath) as _TimelineDisplayer
onready var _history_menu:MenuButton = get_node(HistoryMenuPath) as MenuButton


func fake_ready() -> void:
	_timeline_displayer.set_drag_forwarding(self)
	get_tree().root.connect("gui_focus_changed", self, "_on_global_focus_changed", [], CONNECT_DEFERRED)
	_registered_events.connect("changed", self, "_on_RegisteredEvents_changed")
	
	_history_popup_menu = _history_menu.get_popup()
	_history_popup_menu.connect("id_pressed", self, "_on_HistoryMenu_id_pressed")
	_history_menu.icon = get_icon("History", "EditorIcons")


func edit_resource(resource) -> void:
	if _edited_resource:
		if _edited_resource.is_connected("changed", _timeline_displayer, "reload"):
			_edited_resource.disconnect("changed", _timeline_displayer, "reload")
	
	_edited_resource = resource as Timeline
	_UndoRedo.clear_history(false)
	
	_update_values()


func _update_values() -> void:
	if _edited_resource == null:
		_timeline_displayer.call("_unload_events")
	
	elif not _edited_resource is Timeline:
		_edited_resource = null
		push_error(str(_edited_resource) + " is not Timeline")
		_timeline_displayer.call("_unload_events")
		return
	
	_connect_resource_signals()
	_update_displayed_name()
	_generate_event_buttons()
	_update_timeline_displayer()
	_update_history()


func _connect_resource_signals() -> void:
	if not _edited_resource:
		return
	
	if not _edited_resource.is_connected("changed", _timeline_displayer, "reload"):
		_edited_resource.connect("changed", _timeline_displayer, "reload")


func _update_displayed_name() -> void:
	var _name:String = "[Load a Timeline to create and edit events]"
	
	if _edited_resource:
		# In the future I'll take a look at this line and ask:
		# "why didn't I used .format()?" and I'll reply "I was lazy that time"
		_name = "%s | [%s]"%[_edited_resource.resource_name,_edited_resource.resource_path]
	
	_name_node.text = _name


func _update_history() -> void:
	if not _edited_resource:
		return
	
	var _path:String = _name_node.text
	var refs := []
	
	for weak_ref in _history:
		var ref:WeakRef = (weak_ref as WeakRef)
		
		if ref == null:
			continue
		
		var res:Resource = ref.get_ref()
		refs.append(res)
	
	if _edited_resource in refs:
		refs.erase(_edited_resource)
	
	refs.append(_edited_resource)
	
	_history_popup_menu.clear()
	for res in refs:
		if res == null:
			continue
		_path =  "%s | [%s]"%[res.resource_name,res.resource_path]
		_history_popup_menu.add_item(_path)
	
	_history = []
	for res in refs:
		_history.append(weakref(res))
	refs = []
	

func _generate_event_buttons() -> void:
	if not _edited_resource:
		_category_manager.clear_all()
		return
	
	var _events:Array = _registered_events["events"].duplicate()
	for event in _events:
		var _dummy = event.new() as Event
		if _dummy == null:
			# Someone forgots that the resource is only for event scripts and nothing else.
			# Let's give it a hand!
			continue
		_dummy = null
		_category_manager.add_event(event)


func _generate_separator_node() -> void:
	_separator_node = load("res://addons/event_system_plugin/nodes/editor/event_node/event_node.tscn").instance()
	_separator_node.set_drag_forwarding(self)
	_separator_node.modulate.a = 0.5
	_separator_node.modulate = _separator_node.modulate.darkened(0.2)


func _update_timeline_displayer() -> void:
	if _edited_resource:
		_timeline_displayer.load_timeline(_edited_resource)
	_timeline_displayer.reload()


func _add_event(event:Event, at_position:int=-1) -> void:
	_UndoRedo.create_action("Add event to timeline")
	_UndoRedo.add_do_method(_edited_resource, "add_event", event, at_position)
	_UndoRedo.add_undo_method(_edited_resource, "erase_event", event)
	_UndoRedo.commit_action()


func _remove_event(event:Event) -> void:
	var event_idx:int = _edited_resource.get_events().find(event)
	_UndoRedo.create_action("Remove event from timeline")
	_UndoRedo.add_do_method(_edited_resource, "erase_event", event)
	_UndoRedo.add_undo_method(_edited_resource, "add_event", event, event_idx)
	_UndoRedo.commit_action()


func _on_CategoryManager_event_pressed(event:Event) -> void:
	var idx:int = -1
	if is_instance_valid(_last_focused_event_node):
		idx = int(_last_focused_event_node.get("event_index"))+1
	
	_add_event(event, idx)


func _on_TimelineDisplayer_event_node_added(event_node:Control) -> void:
	event_node.set_drag_forwarding(self)
	event_node.connect("gui_input", self, "_on_EventNode_gui_input", [event_node])
	if event_node.has_signal("timeline_selected"):
		event_node.connect("timeline_selected", self, "_on_EventNode_timeline_selected")


func _on_RegisteredEvents_changed() -> void:
	_category_manager.clear_all()
	_generate_event_buttons()


func _on_global_focus_changed(control:Control) -> void:
	if _category_manager.is_a_parent_of(control):
		return
	
	if control is _TimelineDisplayer._EventNode:
		_last_focused_event_node = control
		emit_signal("event_selected", control.get("event"))
		return
	
	_last_focused_event_node = null


func _on_EventNode_gui_input(event: InputEvent, event_node) -> void:
	if event is InputEventKey:
		if event.scancode == KEY_DELETE:
			var _event = event_node.get("event")
			_remove_event(_event)
			accept_event()


func _on_EventNode_timeline_selected(timeline:Timeline) -> void:
	if not timeline:
		return
	
	var _timeline_popup := AcceptDialog.new()
	_timeline_popup.connect("ready", _timeline_popup, "popup_centered_ratio", [0.35])
	_timeline_popup.connect("popup_hide", _timeline_popup, "queue_free")
	_timeline_popup.connect("hide", _timeline_popup, "queue_free")
	_timeline_popup.rect_clip_content = false
	_timeline_popup.window_title = "Timeline Preview"
	var _edit_button = _timeline_popup.add_button("Edit timeline", true, "")
	_edit_button.connect("pressed", _PluginScript, "_on_TimelineEditor_preview_edit_pressed", [timeline])
	_edit_button.connect("pressed", _timeline_popup, "hide")
	var _scroll := ScrollContainer.new()
	_timeline_popup.add_child(_scroll)
	var _editor_duplicate := _TimelineDisplayer.new()
	
	_editor_duplicate.connect("ready", _editor_duplicate, "load_timeline", [timeline])
	_scroll.add_child(_editor_duplicate)
	
	add_child(_timeline_popup)


func _on_LoadTimelineButton_pressed() -> void:
	var _file_popup := EditorFileDialog.new()
	_file_popup.theme = Theme.new()
	_file_popup.connect("ready", _file_popup, "popup_centered_ratio")
	_file_popup.connect("file_selected", self, "_on_FilePopup_file_selected")
	_file_popup.connect("popup_hide", _file_popup, "queue_free")
	_file_popup.mode = 0
	_file_popup.add_filter("*.tres;Timeline Resource")
	_file_popup.add_filter("*.res;Timeline Resource")
	_file_popup.popup_exclusive = true
	add_child(_file_popup)


func _on_FilePopup_file_selected(file_path:String) -> void:
	edit_resource(load(file_path))


func _on_HistoryMenu_id_pressed(idx:int) -> void:
	_PluginScript.get_editor_interface().edit_resource(_history[idx].get_ref())


###########
# Drag&Drop(TM)
###########

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAG_BEGIN:
			_on_drag_begin()
		NOTIFICATION_DRAG_END:
			_on_drag_end()


func _on_drag_begin() -> void:
	var drag_data = get_tree().root.gui_get_drag_data()
	
	if not drag_data:
		return
	
	if not(drag_data is Event):
		return
	
	_remove_event(drag_data)
	
	if not is_instance_valid(_separator_node):
		_generate_separator_node()


func _on_drag_end() -> void:
	if is_instance_valid(_separator_node):
		_separator_node.queue_free()


func can_drop_data_fw(position: Vector2, data, node:Control) -> bool:
	if not(data is Event):
		return false
	
	if node == _timeline_displayer:
		return true
	
	if node == _separator_node:
		return true
	
	var node_rect:Rect2 = node.get_rect()
	var node_idx:int = int(node.get("event_index"))
	
	_separator_node.set("event_index", node_idx)
	
	
	var _drop_index_hint:int = -1
	if position.y > node_rect.size.y/2:
		_drop_index_hint = node_idx+1
	else:
		_drop_index_hint = node_idx
	
	if not _timeline_displayer.is_a_parent_of(_separator_node):
		if _separator_node.is_inside_tree():
			_separator_node.get_parent().remove_child(_separator_node)
		_timeline_displayer.add_child(_separator_node)
	
	_separator_node.set("event", data)
	_separator_node.set("event_index", _drop_index_hint)
	_separator_node.call("_update_event_colors")
	_separator_node.call("_update_event_name")
	_separator_node.call("_update_event_index")
	
	_timeline_displayer.move_child(_separator_node, _drop_index_hint)
	
	return true


func drop_data_fw(position: Vector2, data, node) -> void:
	if node == _timeline_displayer and data is Event:
		_add_event(data)
		return
	
	var _position:int = _separator_node.event_index
	_add_event(data, _position)
