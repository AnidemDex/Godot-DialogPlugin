extends WAT.Test

var resource_array:ResourceArray
var generic_resource

func pre() -> void:
	resource_array = ResourceArray.new()


func pos() -> void:
	resource_array = null
	generic_resource = null


func test_when_you_add_resource_to_resource_array() -> void:
	generic_resource = Resource.new()
	resource_array.add(generic_resource)
	asserts.is_true(generic_resource in resource_array.get_resources())


func test_when_is_inside_on_another_resource() -> void:
	# Quizás deba revisar esta de aca
	generic_resource = DialogTimelineResource.new()
	asserts.is_true(generic_resource.events is ResourceArray)
	

func title() -> String:
	return "Resource Array"
