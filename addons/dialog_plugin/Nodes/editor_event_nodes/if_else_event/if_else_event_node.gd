tool
extends DialogEditorEventNode

## Use _save_resource() method everywhere you update the base_resource
## properties. Then, call again _update_node_values if you want

const EventDisplayer = preload("res://addons/dialog_plugin/Editor/Views/timeline_editor/events_displayer.gd")

export(NodePath) var ConditionPreview_Path:NodePath
export(NodePath) var Condition_Path:NodePath
export(NodePath) var IfEvents_Path:NodePath
export(NodePath) var ElseEvents_Path:NodePath

var timeline_resource:DialogTimelineResource setget _set_timeline

onready var condition_preview_node:Label = get_node(ConditionPreview_Path) as Label
onready var condition_node:LineEdit = get_node(Condition_Path) as LineEdit
onready var if_events_node:EventDisplayer = get_node(IfEvents_Path) as EventDisplayer
onready var else_events_node:EventDisplayer = get_node(ElseEvents_Path) as EventDisplayer

func _ready() -> void:
	# ALWAYS verify if you had a base_resource
	
	if base_resource:
		# You can prepare your nodes here before updating its values
		emit_signal("timeline_requested", self)


func _update_node_values() -> void:
	condition_preview_node.text = "if ( {0} ) then...".format([base_resource.condition])
	
	condition_node.text = base_resource.condition
	
	if_events_node.timeline_resource = base_resource.events_if
	if_events_node.timeline_resource._related_characters = timeline_resource._related_characters
	
	else_events_node.timeline_resource = base_resource.events_else
	else_events_node.timeline_resource._related_characters = timeline_resource._related_characters
	
	if_events_node.force_reload()
	else_events_node.force_reload()


func _focused():
	._focused()
	condition_preview_node.visible = !_is_focused


func _unfocused():
	if get_focus_owner() is DialogEditorEventNode:
		._unfocused()
		condition_preview_node.visible = !_is_focused


func can_drop_data(position: Vector2, data) -> bool:
	if data is DialogEventResource:
		var _top_container_node = top_content_node.get_node("HContainer")
		if not _top_container_node:
			return false
		_top_container_node.toggle(true)
	return false


func _on_event_being_dragged() -> void:
	if_events_node._on_event_being_dragged()


func _set_timeline(value:DialogTimelineResource) -> void:
	timeline_resource = value
	_update_node_values()


func _on_IF_Event_save() -> void:
	if not if_events_node.loading_events:
		_save_resource()


func _on_Condition_text_changed(new_text: String) -> void:
	base_resource.condition = new_text


func _on_Condition_text_entered(new_text: String) -> void:
	_on_Condition_text_changed(new_text)
	condition_node.release_focus()
	_save_resource()


func _on_Else_Events_save() -> void:
	if not else_events_node.loading_events:
		_save_resource()
