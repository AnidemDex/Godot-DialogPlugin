tool
extends "res://addons/dialog_plugin/Nodes/misc/OptionButtonGenerator.gd"

var timeline_resource:DialogTimelineResource = null setget _set_timeline_resource

func generate_items() -> void:
	clear()
	
	add_item("[None]")
	set_item_metadata(0, {"value": -1})
	if not timeline_resource:
		return
	
	var _idx = 1
	for event in timeline_resource.events:
		var good_name = {"res_name":event.resource_name, "idx":_idx-1}
		add_item("{res_name}: {idx}".format(good_name))
		set_item_metadata(_idx, {"value": _idx-1})
		_idx += 1
		pass
	
	

func _set_timeline_resource(value:DialogTimelineResource) -> void:
	timeline_resource = value
	generate_items()
	pass
