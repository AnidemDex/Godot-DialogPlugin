tool
extends DialogEditorEventNode

## Use _save_resource() method everywhere you update the base_resource
## properties. Then, call again _update_node_values if you want

export(NodePath) var Timeline_path:NodePath
export(NodePath) var EventOption_path:NodePath
export(NodePath) var EventList_path:NodePath

var timeline_resource:DialogTimelineResource setget _set_timeline

onready var timeline_node:Button = get_node(Timeline_path) as Button
onready var event_option_node:Control = get_node(EventOption_path) as Control
onready var event_list_node:OptionButton = get_node(EventList_path) as OptionButton

func _ready() -> void:
	# ALWAYS verify if you had a base_resource
	#DialogChangeTimelineEvent
	if base_resource:
		# You can prepare your nodes here before updating its values
		emit_signal("timeline_requested",self)

func _update_node_values() -> void:
	if base_resource.timeline_path:
		timeline_node.text = base_resource.timeline_path.get_file()
	else:
		timeline_node.text = "None"
	
	if base_resource.timeline_path != "":
		event_option_node.visible = true
		event_list_node.select(base_resource.start_from_event)
	else:
		event_option_node.visible = false


func _set_timeline(value:DialogTimelineResource) -> void:
	timeline_resource = value
	event_list_node.timeline_resource = base_resource.timeline
	_update_node_values()


func _on_TimelineButton_pressed() -> void:
	$FileDialog.popup_centered_ratio()


func _on_FileDialog_file_selected(path: String) -> void:
	if not base_resource:
		return
	
	var _timeline = load(path)
	if _timeline is DialogTimelineResource and _timeline != timeline_resource:
		base_resource.timeline_path = path
		event_list_node.timeline_resource = _timeline
	else:
		base_resource.timeline = null
		base_resource.timeline_path = ""
		event_list_node.timeline_resource = null
	_save_resource()
	_update_node_values()


func _on_EventList_item_selected(index: int) -> void:
	base_resource.start_from_event = index
	_save_resource()
	_update_node_values()
