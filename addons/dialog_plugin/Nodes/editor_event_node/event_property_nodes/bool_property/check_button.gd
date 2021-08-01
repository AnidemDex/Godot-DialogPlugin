tool
extends CheckButton

var used_property:String
var base_resource:DialogEventResource

func _ready() -> void:
	if not base_resource:
		return
	
	base_resource.connect("changed", self, "update_node_values")
	update_node_values()


func _toggled(button_pressed: bool) -> void:
	base_resource.set(used_property, button_pressed)


func update_node_values() -> void:
	pressed = base_resource.get(used_property)
