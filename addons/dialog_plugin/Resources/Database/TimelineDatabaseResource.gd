tool
extends DialogDatabaseResource

var DialogUtil := load("res://addons/dialog_plugin/Core/DialogUtil.gd")

func add(res:Resource):
	if not(res is DialogTimelineResource):
		push_error("resource is not a timeline")
		return
	if res in resources.get_resources():
		push_warning("A resource is already there")
		var _r_array = resources.get_resources()
		var _idx = _r_array.find(res)
		if _idx != -1:
			_r_array[_idx] = res
			save(DialogResources.TIMELINEDB_PATH)
			emit_signal("changed")
		return
	DialogUtil.Logger.print(self,["adding a resource:",res.resource_path])
	(resources as ResourceArray).add(res)
	save(DialogResources.TIMELINEDB_PATH)
	emit_signal("changed")

func remove(item) -> void:
	if not(item is DialogTimelineResource):
		push_error("item is not a timeline")
		return
	DialogUtil.Logger.print(self,["removing a resource:",item.resource_path])
	(resources as ResourceArray).remove(item)
	save(DialogResources.TIMELINEDB_PATH)
	emit_signal("changed")


func scan_resources_folder() -> void:
	push_warning("Scanning timelines folder")
	var _files:PoolStringArray = _get_files_in_directory(DialogResources.TIMELINES_DIR)
	
	for file in _files:
		var _resource = load(file)
		if not _resource in resources.get_resources():
			push_warning("{} is not in the database, adding...".format({"":file.get_file()}))
			add(_resource)
		_resource = null
	push_warning("Done")

func _to_string() -> String:
	return "[TimelineDatabase]"
