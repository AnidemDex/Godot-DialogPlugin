tool
extends "res://addons/dialog_plugin/Nodes/misc/OptionButtonGenerator.gd"

var timeline_resource:DialogTimelineResource setget _set_timeline

func generate_items() -> void:	
	if timeline_resource:
		clear()
		var _idx = 0
		for event in timeline_resource.events.get_resources():
			add_item(str(_idx), _idx)
			set_item_metadata(_idx, _idx)
			_idx += 1


func _set_timeline(value:DialogTimelineResource) -> void:
	timeline_resource = value
	generate_items()
