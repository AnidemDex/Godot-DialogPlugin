extends WAT.Test

var timeline

func title() -> String:
	return "Timeline Resource"


func pre() -> void:
	timeline = DialogTimelineResource.new()

func pos() -> void:
	timeline = null

func test_has_basic_properties() -> void:
	asserts.is_true("events" in timeline, "Has .events")
	asserts.is_true("current_event" in timeline, "Has .current_event index")
