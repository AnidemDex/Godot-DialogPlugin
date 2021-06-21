tool
extends CheckBox

func _ready() -> void:
	add_icon_override("unchecked", get_icon("increment", "TabContainer"))
	add_icon_override("checked", get_icon("decrement", "TabContainer"))
