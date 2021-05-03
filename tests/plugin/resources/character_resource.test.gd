extends WAT.Test

var character

func title() -> String:
	return "Character Resource"


func pre()->void:
	character = DialogCharacterResource.new()


func pos() -> void:
	character = null


func test_has_basic_properties() -> void:
	asserts.is_true("name" in character, "Has .name")
	asserts.is_true("display_name" in character, "Has .display_name")
	asserts.is_true("color" in character, "Has .color")
	asserts.is_true("portraits" in character, "Has .portraits")
	asserts.is_true("display_name_bool" in character, "Has .display_name_bool")
