tool
extends Resource

export(PoolStringArray) var resources_path = PoolStringArray([])

func add(path:String) -> void:
	var _res:Array = Array(resources_path)
	var _idx = _res.find(path)
	if _idx != -1:
		resources_path.set(_idx, path)
	else:
		resources_path.append(path)
	emit_changed()

func remove(path:String) -> void:
	var _res:Array = Array(resources_path)
	var _idx = _res.find(path)
	if _idx != -1:
		resources_path.remove(_idx)
		emit_changed()

func _to_string() -> String:
	return "[TimelineDatabase]"
