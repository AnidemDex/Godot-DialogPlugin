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

var timeline_resource:DialogTimelineResource
var last_selected_node:DialogEditorEventNode
var separator_node:Control = PanelContainer.new()

var loading_events:bool = false setget set_loading, is_loading
var modified:bool = false setget _set_modified
var load_thread:Thread = Thread.new()
var mutex:Mutex = Mutex.new()
var progress_mutex:Mutex = Mutex.new()
var load_progress:float = 0.0 setget set_load_progress, get_load_progress

onready var viewport:Viewport = get_viewport()

func _ready() -> void:
	configure_separator_node()


func _process(delta: float) -> void:
	if viewport.gui_is_dragging() and viewport.gui_get_drag_data() is DialogEventResource:
		_event_being_dragged()
	else:
		_event_ended_dragged()


func _exit_tree() -> void:
	if load_thread.is_active():
		load_thread.wait_to_finish()


func configure_separator_node() -> void:
	var stylebox:StyleBoxFlat = load("res://addons/dialog_plugin/assets/Themes/event_preview_separator.tres")
	separator_node.add_stylebox_override("panel", stylebox)
	separator_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	separator_node.rect_min_size = Vector2(0, 32)
	
	if not is_a_parent_of(separator_node):
		add_child(separator_node)
	separator_node.hide()


func add_event(event:DialogEventResource, in_place:int=-1) -> void:
	DialogUtil.Logger.print_debug(self, "Attemping to add {0} event in {1}".format([event.get_class(), in_place]))
	var _events:Array = timeline_resource.events

	if in_place != -1:
		_events.insert(in_place, event)
	else:
		_events.append(event)
	
	set("modified", true)
	force_reload()


func unload_events():
	DialogUtil.Logger.print_debug(self, "Unloading {0} events...".format([get_child_count()]))
	for child in get_children():
		if child == separator_node:
			continue
		child.queue_free()
	DialogUtil.Logger.print_debug(self, "Done!")

var events_to_load:int

func load_events():
	
	events_to_load = timeline_resource.events.size()
	
	DialogUtil.Logger.print_debug(self, "Loading {0} events...".format([events_to_load]))
	if load_thread.is_active():
		load_thread.wait_to_finish()
	load_next_event()
	DialogUtil.Logger.print_debug(self, "Done!")

func load_from_event(event_idx:int=0) -> void:
	set_loading(true)
	var _events:Array = timeline_resource.events
	for _event_idx in _events.size():
		var event:DialogEventResource = _events[_event_idx] as DialogEventResource
		progress_mutex.lock()
		load_progress = _event_idx/float(events_to_load)
		progress_mutex.unlock()
		emit_signal("displayer_loading")
		add_event_node_as_child(event, _event_idx)
	emit_signal("displayer_loaded")
	set_loading(false)
	load_thread.call_deferred("wait_to_finish")

func load_next_event(next_event_idx:int=0) -> void:
	if load_thread.is_active():
		load_thread.wait_to_finish()
	load_thread.start(self, "load_from_event", next_event_idx)


func add_event_node_as_child(event:DialogEventResource, index_hint:int) -> void:
	var _err:int
	var event_node:DialogEditorEventNode = event.get_event_editor_node()

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
	_err = event_node.connect("ready", event_node, "set", ["idx", index_hint])
	assert(_err == OK)
	event_node.set_drag_forwarding(self)
	call_deferred("add_child", event_node)
	DialogUtil.Logger.print_debug(event, "Added to event displayer")


func force_reload() -> void:
	DialogUtil.Logger.print_debug(self, "Reloading...")
	unload_events()
	load_events()
	DialogUtil.Logger.print_debug(self, "Reloaded!")


func set_loading(value:bool) -> void:
	mutex.lock()
	loading_events = value
	mutex.unlock()


func is_loading() -> bool:
	var loading:bool
	mutex.lock()
	loading = loading_events
	mutex.unlock()
	return loading


func set_load_progress(value:float) -> void:
	progress_mutex.lock()
	load_progress = value
	progress_mutex.unlock()


func get_load_progress() -> float:
	progress_mutex.lock()
	var progress:float = load_progress
	progress_mutex.unlock()
	return progress


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
		_drop_index_hint = node.idx+1
	else:
		_drop_index_hint = node.idx
	
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
