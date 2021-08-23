extends "res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/event_property.gd".PControl

var fixed_type:String = ""

func update_node_values() -> void:
	pass

func _on_AddKeyButton_item_selected(item_string:String) -> void:
	var type:int = TYPE_NIL
	match item_string:
		"Bool":
			type = TYPE_BOOL
		"String":
			type = TYPE_STRING
		"Int":
			type = TYPE_INT
		"Float":
			type = TYPE_REAL
