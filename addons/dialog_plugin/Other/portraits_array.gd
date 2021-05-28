tool
extends "res://addons/dialog_plugin/Other/resource_array.gd"
class_name PortraitArray

func _init() -> void:
	resource_name = "PortraitArray"
	_hint_string = "DialogPortraitResource"

func add(resource:Resource) -> void:
	if resource is DialogPortraitResource:
		_resources.append(resource)
		property_list_changed_notify()
		emit_signal("changed")
	else:
		push_warning("Trying to add an uncompatible value. Ignoring.")
