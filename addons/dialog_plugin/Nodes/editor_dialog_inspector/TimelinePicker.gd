tool
extends OptionButton

const DialogDB = preload("res://addons/dialog_plugin/Core/DialogDatabase.gd")

func _ready() -> void:
	for _item_idx in range(get_item_count()):
		var _idx = clamp(_item_idx-1, 0, get_item_count())
		remove_item(_idx)
	
	add_item("[Empty]")
	set_item_metadata(0, "")
	
	var _idx = 1
	for timeline in DialogDB.Timelines.get_timelines():
		timeline = timeline as DialogTimelineResource
		add_item(timeline.resource_path.get_file().replace(".tres", ""))
		set_item_metadata(_idx, timeline.resource_path)
		_idx += 1

func select_item_by_resource_path(path:String) -> void:
	for _item_idx in range(get_item_count()):
		var _idx = clamp(_item_idx, 0, get_item_count())
		var _item_resource = get_item_metadata(_idx)
		if _item_resource == path:
			select(_idx)
		
