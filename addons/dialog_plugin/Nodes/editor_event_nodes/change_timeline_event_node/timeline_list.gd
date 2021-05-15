tool
extends "res://addons/dialog_plugin/Nodes/misc/OptionButtonGenerator.gd"

var DialogDB := load("res://addons/dialog_plugin/Core/DialogDatabase.gd")
var timeline:DialogTimelineResource setget _set_timeline

func generate_items() -> void:
	
	clear()
	var _timelines:Array = DialogDB.Timelines.get_timelines()
	
	add_item("[None]")
	set_item_metadata(0, {"timeline":null})
	
	var _idx = 1
	for _timeline in _timelines:
		_timeline = _timeline as DialogTimelineResource
		
		if _timeline == timeline:
			continue
		
		add_item(_timeline.resource_path.get_file().replace(".tres", ""))
		set_item_metadata(_idx, {"timeline": _timeline})
		_idx += 1

func _set_timeline(value:DialogTimelineResource) -> void:
	timeline = value
	generate_items()
