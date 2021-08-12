tool
extends Container

# Lo cree para gestionar los eventos que iban a ser añadidos
# bajo la promesa de Drag&Drop.
# Puede ser añadido a cualquier contenedor

signal save()
signal modified
signal displayer_loading
signal displayer_loaded

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")

var event_node_template_scene:PackedScene = preload("res://addons/dialog_plugin/Nodes/editor_event_node/event_node_template.tscn")

var timeline_resource:DialogTimelineResource
var last_selected_node:DialogEditorEventNode
var separator_node:Control = PanelContainer.new()

var loading_events:bool = false setget set_loading, is_loading
var modified:bool = false setget _set_modified
var load_progress:float = 0.0 setget set_load_progress, get_load_progress

var loaded_events:Array = []

onready var viewport:Viewport = get_viewport()

func _ready() -> void:
	configure_separator_node()


func _process(delta: float) -> void:
	if viewport.gui_is_dragging() and viewport.gui_get_drag_data() is DialogEventResource:
		_event_being_dragged()
	else:
		_event_ended_dragged()


func configure_separator_node() -> void:
	var stylebox:StyleBoxFlat = load("res://addons/dialog_plugin/assets/Themes/event_preview_separator.tres")
	separator_node.add_stylebox_override("panel", stylebox)
	separator_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	separator_node.rect_min_size = Vector2(0, 32)
	
	if not is_a_parent_of(separator_node):
		add_child(separator_node)
	separator_node.hide()


func add_event(event:DialogEventResource, in_place:int=-1) -> void:
	DialogUtil.Logger.print_debug(self, "Attemping to add {0} event in position {1}".format([event.get_class(), in_place]))
	var _events:Array = timeline_resource.events

	if in_place > -1:
		in_place = min(_events.size(), in_place)
		_events.insert(in_place, event)
	else:
		_events.append(event)
	
	set("modified", true)
	force_reload()


func unload_events():
	DialogUtil.Logger.print_debug(self, "Unloading {0} events...".format([get_child_count()]))
	
	var events:Array = loaded_events.duplicate()
	for event in events:
		remove_event_from_displayer(event)
	
	DialogUtil.Logger.print_debug(self, "Done!")


func load_events():
	load_event_from()


func load_event_from(event_idx:int=0) -> void:
	if timeline_resource == null:
		DialogUtil.Logger.print_debug(self, "Trying to load events, but there's no timeline to load!")
		emit_signal("displayer_loaded")
		set_loading(false)
		return
	
	set_loading(true)
	var _events:Array = timeline_resource.events
	
	if event_idx >= _events.size():
		DialogUtil.Logger.print_debug(self, "Load index out of bounds. Probably end of the load, exiting...")
		emit_signal("displayer_loaded")
		set_loading(false)
		return
	
	load_progress = float(event_idx) / float(_events.size())
	emit_signal("displayer_loading")
	
	var _event:DialogEventResource = _events[event_idx]
	DialogUtil.Logger.print_debug(self, "Loading event {0} of {1}: {2}".format([event_idx+1, _events.size(), _event.get("resource_name")]))
	
	if not is_already_loaded(_event):
		loaded_events.insert(event_idx, _event)
		add_event_node_as_child(_event, event_idx)
	
	elif not is_event_at_right_position(_event):
		remove_event_from_displayer(_event)
		loaded_events.insert(event_idx, _event)
		add_event_node_as_child(_event, event_idx)
	
	yield(get_tree(), "idle_frame")
	call_deferred("load_event_from", event_idx+1)


func is_already_loaded(event:DialogEventResource) -> bool:
	return event in loaded_events


func is_event_at_right_position(event:DialogEventResource) -> bool:
	var original_position:int = timeline_resource.events.find(event)
	var node_idx:int = -2
	for child in get_children():
		child = child as Node
		var _base_resource = child.get("base_resource")
		if event == _base_resource:
			node_idx = child.get("event_index")
	return node_idx == original_position


func remove_event_from_displayer(event:DialogEventResource) -> void:
	if event == null:
		return
	
	for child in get_children():
		child = child as Node
		var _base_resource = child.get("base_resource")
		if event == _base_resource:
			child.queue_free()
			loaded_events.erase(event)
			break


func add_event_node_as_child(event:DialogEventResource, index_hint:int) -> void:
	var _err:int
	var event_node:DialogEditorEventNode = get_editor_node_for_event(event)

	_err = event_node.connect("focus_entered", self, "_on_EventNode_selected")
	assert(_err == OK)
	_err = event_node.connect("focus_exited", self, "_on_EventNode_deselected")
	assert(_err == OK)
	_err = event_node.connect("deletion_requested", self, "_on_EventNode_deletion_requested")
	assert(_err == OK)
	_err = event_node.connect("event_modified", self, "_on_EventNode_modified")
	assert(_err == OK)
	_err = event_node.connect("timeline_requested", self, "_on_EventNode_timeline_requested")
	assert(_err == OK)
	event_node.connect("ready", event_node, "call", ["update_event_node_values"])
	event_node.event_index = index_hint
	event_node.base_resource = event
	event_node.name = event.event_name
	event_node.set_drag_forwarding(self)
	call_deferred("add_child", event_node)
	call_deferred("move_child", event_node, index_hint)
	DialogUtil.Logger.print_debug(event, "Added to event displayer")


func force_reload() -> void:
	DialogUtil.Logger.print_debug(self, "Reloading...")
	load_events()


func set_loading(value:bool) -> void:
	loading_events = value


func is_loading() -> bool:
	return loading_events


func set_load_progress(value:float) -> void:
	push_warning("You can't set the value of the progress bar!")


func get_load_progress() -> float:
	return load_progress

func get_editor_node_for_event(event:DialogEventResource) -> DialogEditorEventNode:
	var event_node_template:DialogEditorEventNode
	if event.event_editor_scene_path != "" and ResourceLoader.exists(event.event_editor_scene_path):
		event_node_template = load(event.event_editor_scene_path).instance()
	else:
		event_node_template = event_node_template_scene.instance() as DialogEditorEventNode
	
	return event_node_template


func _set_modified(value:bool) -> void:
	modified = value
	DialogUtil.Logger.print_debug(self, "modified set to {0}, emmiting modified signal".format([value]))
	emit_signal("modified")


func _on_EventNode_selected(event_node:DialogEditorEventNode=null) -> void:
	if not event_node:
		return
	
	last_selected_node = event_node


func _on_EventNode_deselected(event_node:DialogEditorEventNode=null) -> void:
	if not event_node:
		return
	
	var _focus_owner = get_focus_owner()
	if _focus_owner and _focus_owner is DialogEditorEventNode:
		if event_node == last_selected_node:
			last_selected_node = null


func _on_EventNode_deletion_requested(event_resource:DialogEventResource=null) -> void:
	if not event_resource:
		return
	DialogUtil.Logger.print_debug(event_resource, "Requested to be removed.")
	var _events:Array = timeline_resource.events
	_events.erase(event_resource)
	remove_event_from_displayer(event_resource)
	set("modified", true)
	force_reload()


func _on_EventNode_modified(event_resource:DialogEventResource=null) -> void:
	if not is_loading():
		set("modified", true)


func _on_EventNode_timeline_requested(node:DialogEditorEventNode) -> void:
	node.set("timeline_resource", timeline_resource)


######################
#    DRAG AND DROP   #
######################


var _drop_index_hint:int = -1


func can_drop_data_fw(position: Vector2, data, node:Control) -> bool:
	if node.has_method("can_drop_data"):
		node.can_drop_data(position, data)
	
	var node_rect:Rect2 = node.get_rect()
	
	if position.y > node_rect.size.y/2:
		_drop_index_hint = int(node.get("event_index"))+1
	else:
		_drop_index_hint = int(node.get("event_index"))
	
	move_child(separator_node, _drop_index_hint)
	
	return false


func can_drop_data(position, data):
	return data is DialogEventResource


func drop_data(position, data):
	add_event(data, _drop_index_hint)
	_drop_index_hint = -1


func _event_being_dragged() -> void:
	set("custom_constants/separation", 4)
	separator_node.show()


func _event_ended_dragged() -> void:
	set("custom_constants/separation", 0)
	separator_node.hide()
