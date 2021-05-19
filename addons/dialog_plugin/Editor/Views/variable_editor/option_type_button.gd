tool
extends "res://addons/dialog_plugin/Nodes/misc/OptionButtonGenerator.gd"

func generate_items() -> void:
	clear()
	
	add_item("Variant")
	add_item("Boolean")
	add_item("Integer")
	add_item("Float")
	add_item("String")
	
	# https://docs.godotengine.org/es/stable/classes/class_%40globalscope.html#enum-globalscope-variant-type
	set_item_metadata(0, TYPE_MAX)
	set_item_metadata(1, TYPE_BOOL)
	set_item_metadata(2, TYPE_INT)
	set_item_metadata(3, TYPE_REAL)
	set_item_metadata(4, TYPE_STRING)
	
	select(0)
