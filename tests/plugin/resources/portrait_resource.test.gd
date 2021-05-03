extends WAT.Test

var portrait

func title() -> String:
	return "Portrait Resource"

func pre() -> void:
	portrait = DialogPortraitResource.new()

func pos() -> void:
	portrait = null

func test_has_basic_properties() -> void:
	asserts.is_true("name" in portrait, "Has .name")
	asserts.is_true("image" in portrait, "Has .image")
