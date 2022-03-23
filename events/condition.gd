tool
extends Event

const _Utils = preload("res://addons/event_system_plugin/core/utils.gd")

export(String) var condition:String = "" setget set_condition
export(Resource) var events_if = Timeline.new() setget set_if_events
export(Resource) var events_else = Timeline.new() setget set_else_events


func _init() -> void:
	event_name = "Condition"
	event_color = Color("#FBB13C")
	event_icon = load("res://addons/event_system_plugin/assets/icons/event_icons/condition_event.png") as Texture
	event_preview_string = "If [ {condition} ]:"
	event_hint = "Similar to if-else statement.\nEvaluates a condition and execute events accordingly."
	event_category = "Logic"
	continue_at_end = true

	events_if = _get_empty_timeline("Timeline IF")

	events_else = _get_empty_timeline("Timeline ELSE")
	push_warning("Event condition is deprecated and was replaced by a new one. Will be removed in new versions.")



func _get(property: String):
	if property == "continue_at_end_ignore":
		return true


func set_condition(value:String) -> void:
	condition = value
	emit_changed()
	property_list_changed_notify()


func set_if_events(value:Timeline) -> void:
	if events_if.is_connected("changed", self, "timeline_changed"):
		events_if.disconnect("changed", self, "timeline_changed")
	events_if = value
	if not events_if.is_connected("changed", self, "timeline_changed"):
		events_if.connect("changed", self, "timeline_changed")
	emit_changed()
	property_list_changed_notify()


func set_else_events(value:Timeline) -> void:
	if events_else.is_connected("changed", self, "timeline_changed"):
		events_else.disconnect("changed", self, "timeline_changed")
	events_else = value
	if not events_else.is_connected("changed", self, "timeline_changed"):
		events_else.connect("changed", self, "timeline_changed")
	emit_changed()
	property_list_changed_notify()


func timeline_changed() -> void:
	emit_changed()
	property_list_changed_notify()


func property_can_revert(property:String) -> bool:
	match property:
		"events_if", "events_else":
			return true
	return false


func property_get_revert(property:String): # -> Variant() type
	if property == "events_if":
		return _get_empty_timeline("Timeline IF")
	if property == "events_else":
		return _get_empty_timeline("Timeline ELSE")
	return null


func _get_empty_timeline(with_name:String) -> Timeline:
	var tmln := Timeline.new()
	if with_name != "":
		tmln.resource_name = with_name
	return tmln
