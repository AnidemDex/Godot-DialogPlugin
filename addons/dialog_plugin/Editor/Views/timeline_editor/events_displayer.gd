tool
extends Container

# Lo cree para gestionar los eventos que iban a ser añadidos
# bajo la promesa de Drag&Drop.
# Puede ser añadido a cualquier contenedor


signal save()

var timeline_resource:DialogTimelineResource

var last_selected_node:DialogEditorEventNode

var separator_node:Control = PanelContainer.new()

var loading_events:bool = false

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
	
	var _events:Array = timeline_resource.events.get_resources()

	if in_place != -1:
		_events.insert(in_place, event)
	else:
		_events.append(event)
	
	emit_signal("save")
	force_reload()


func unload_events():
	for child in get_children():
		if child == separator_node:
			continue
		child.queue_free()


func load_events():
	loading_events = true
	
	var _events:Array = timeline_resource.events.get_resources()
	
	for event_idx in _events.size():
		var event:DialogEventResource = _events[event_idx] as DialogEventResource
		add_event_node_as_child(event, event_idx)
	
	loading_events = false


func add_event_node_as_child(event:DialogEventResource, index_hint:int) -> void:
	var _err:int
	var event_node:DialogEditorEventNode = event.get_event_editor_node()

	_err = event_node.connect("focus_entered", self, "_on_EventNode_selected")
	assert(_err == OK)
	_err = event_node.connect("focus_exited", self, "_on_EventNode_deselected")
	assert(_err == OK)
	_err = event_node.connect("deletion_requested", self, "_on_EventNode_deletion_requested")
	assert(_err == OK)
	_err = event_node.connect("save_item_requested", self, "_on_EventNode_save_item_requested")
	assert(_err == OK)
	_err = event_node.connect("timeline_requested", self, "_on_EventNode_timeline_requested")
	assert(_err == OK)
	
	event_node.set_drag_forwarding(self)
	add_child(event_node)
	event_node.idx = index_hint


func force_reload() -> void:
	unload_events()
	load_events()


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
	
	var _events:Array = timeline_resource.events.get_resources()
	_events.erase(event_resource)
	emit_signal("save")
	force_reload()


func _on_EventNode_save_item_requested(event_resource:DialogEventResource) -> void:
	if not loading_events:
		emit_signal("save")


func _on_EventNode_timeline_requested(node:DialogEditorEventNode) -> void:
	node.timeline_resource = timeline_resource


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
	
	emit_signal("save")


func _event_being_dragged() -> void:
	set("custom_constants/separation", 4)
	separator_node.show()

func _event_ended_dragged() -> void:
	set("custom_constants/separation", 0)
	separator_node.hide()
