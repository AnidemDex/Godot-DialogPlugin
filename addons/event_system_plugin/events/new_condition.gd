tool
extends Event
class_name EventCondition

const _Utils = preload("res://addons/event_system_plugin/core/utils.gd")

export(String) var condition:String = ""
var events_if:String setget _set_if_timeline
var events_else:String setget _set_else_timeline

var _events_if:Resource setget set_if_timeline, get_if_timeline
var _events_else:Resource setget set_else_timeline, get_else_timeline

var next_event

func _execute() -> void:
	var variables:Dictionary = _Utils.get_property_values_from(get_event_node())
	
	var evaluated_condition = _Utils.evaluate(condition, get_event_node(), variables)
	
	if evaluated_condition and (str(evaluated_condition) != condition):
		get_event_manager_node().set("timeline", get_if_timeline())
	else:
		get_event_manager_node().set("timeline", get_else_timeline())
	
	next_event = "0"
	
	finish()


func set_if_timeline(timeline:Resource) -> void:
	if _events_if and _events_if.is_connected("changed", self, "set_if_timeline"):
		_events_if.disconnect("changed", self, "set_if_timeline")
	
	_events_if = timeline
	
	var path := ""
	if _events_if:
#		if not _events_if.is_connected("changed", self, "set_if_timeline"):
#			_events_if.connect("changed", self, "set_if_timeline", [_events_if])
		path = _events_if.resource_path
	
	_set_if_timeline(path)


func set_else_timeline(timeline:Resource) -> void:
	if _events_else and _events_else.is_connected("changed", self, "set_else_timeline"):
		_events_else.disconnect("changed", self, "set_else_timeline")
	
	_events_else = timeline
	
	var path := ""
	if _events_else:
#		if not _events_else.is_connected("changed", self, "set_else_timeline"):
#			_events_else.connect("changed", self, "set_else_timeline", [_events_else])
		path = _events_else.resource_path
	
	_set_else_timeline(path)


func get_if_timeline() -> Resource:
	var res:Resource = _events_if
	if ResourceLoader.exists(events_if):
		res = ResourceLoader.load(events_if)
	return res


func get_else_timeline() -> Resource:
	var res:Resource = _events_else
	if ResourceLoader.exists(events_else):
		res = ResourceLoader.load(events_else)
	return res


func _set_if_timeline(timeline_path:String) -> void:
	events_if = timeline_path
	emit_changed()
	property_list_changed_notify()


func _set_else_timeline(timeline_path:String) -> void:
	events_else = timeline_path
	emit_changed()
	property_list_changed_notify()


func _get(property: String):
	if property == "custom_event_node":
		return load("res://addons/event_system_plugin/nodes/editor/event_node/event_condition_node.gd").new()

func _init() -> void:
	event_name = "Condition"
	event_color = Color("#FBB13C")
	event_icon = load("res://addons/event_system_plugin/assets/icons/event_icons/condition_event.png") as Texture
	event_preview_string = "If [ {condition} ]:"
	event_hint = "Similar to if-else statement.\nEvaluates a condition and execute events accordingly."
	event_category = "Logic"
	continue_at_end = true


func _get_property_list() -> Array:
	var p := []
	
	var usage:int = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_CHECKABLE
	if events_if != "":
		usage |= PROPERTY_USAGE_CHECKED
	elif _events_if != null:
		usage |= PROPERTY_USAGE_CHECKED | PROPERTY_USAGE_STORAGE
	p.append({"name":"_events_if", "type":TYPE_OBJECT, "usage":usage})
	
	usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_CHECKABLE
	if events_else != "":
		usage |= PROPERTY_USAGE_CHECKED
	elif _events_else != null:
		usage |= PROPERTY_USAGE_CHECKED | PROPERTY_USAGE_STORAGE
	p.append({"name":"_events_else","type":TYPE_OBJECT, "usage":usage})
	
	p.append({"name":"events_if", "type":TYPE_STRING, "usage":PROPERTY_USAGE_NOEDITOR})
	p.append({"name":"events_else", "type":TYPE_STRING, "usage":PROPERTY_USAGE_NOEDITOR})
	return p
