#class_name TimelineResourceFormatSaver
extends ResourceFormatSaver

func get_recognized_extensions(resource: Resource) -> PoolStringArray:
	var extensions = ["tmln", "tres"]
	if resource is DialogTimelineResource:
		return PoolStringArray(extensions)
	return PoolStringArray()

func recognize(resource: Resource) -> bool:
	return resource is DialogTimelineResource

func save(path: String, resource: Resource, flags: int) -> int:
	print_debug("I dont know what i'm doing")
	return FAILED
