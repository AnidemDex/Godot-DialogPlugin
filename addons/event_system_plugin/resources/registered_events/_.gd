tool
extends Resource

# Array of scripts (to keep their reference through the editor)
export(Array, Script) var events:Array = [] setget _set_events

func _init() -> void:
	events = []

func _set_events(value:Array) -> void:
	events = value.duplicate()
	emit_changed()
	property_list_changed_notify()
	
