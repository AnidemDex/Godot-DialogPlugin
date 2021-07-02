tool
extends VBoxContainer

signal save
signal option_changed(old_option, new_option)

export(NodePath) var OptionLineEdit_path:NodePath
export(NodePath) var Timeline_path:NodePath

const EventDisplayer = preload("res://addons/dialog_plugin/Editor/Views/timeline_editor/events_displayer.gd")

var old_option:String
var option:String setget _set_option
var timeline:DialogTimelineResource setget _set_timeline


onready var option_line_edit_node:LineEdit = get_node(OptionLineEdit_path) as LineEdit
onready var timeline_container_node:EventDisplayer = get_node(Timeline_path) as EventDisplayer

func _on_LineEdit_text_entered(new_text: String) -> void:
	emit_signal("option_changed", old_option, new_text)
	old_option = option
	option = new_text
	grab_focus()


func _set_option(value:String) -> void:
	option = value
	old_option = value
	if is_instance_valid(option_line_edit_node):
		option_line_edit_node.text = option


func _set_timeline(value:DialogTimelineResource) -> void:
	timeline = value
	if is_instance_valid(timeline_container_node):
		timeline_container_node.timeline_resource = timeline
		timeline_container_node.force_reload()


func _on_LineEdit_focus_exited() -> void:
	option_line_edit_node.text = option


func _on_Timeline_save() -> void:
	emit_signal("save")
