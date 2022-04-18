extends EditorInspectorPlugin

const InspectorTools = preload("res://addons/event_system_plugin/core/inspector_tools.gd")

class EventInfo extends VBoxContainer:
	func _init():
		pass
	pass

var EventClass = load("res://addons/event_system_plugin/resources/event_class/event_class.gd")

var editor_gui:Control

func can_handle(object: Object) -> bool:
	return object is EventClass


func parse_category(object: Object, category: String) -> void:
	if category == "Script Variables":
		var category_node := InspectorTools.InspectorCategory.new()
		category_node.label = "Event [%s]"%str(object.get("event_name"))
		category_node.bg_color = object.get("event_color") as Color
		category_node.bg_color.a = 0.4
		category_node.hint_tooltip = object.get("event_hint")
		add_custom_control(category_node)
		
		var event_info


func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	if object == null:
		return false
	var path_ignore = path+"_ignore"
	if (path_ignore in object):
		return true
	
	if path == "next_event":
		var node = InspectorTools.InspectorEventSelector.new()
		add_property_editor(path, node)
		return true
	
	return false
