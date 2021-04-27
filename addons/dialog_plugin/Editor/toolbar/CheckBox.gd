tool
extends CheckBox

func _ready() -> void:
	add_icon_override("unchecked", get_icon("MoveDown", "EditorIcons"))
	add_icon_override("checked", get_icon("MoveUp", "EditorIcons"))
