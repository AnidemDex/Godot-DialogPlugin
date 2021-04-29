tool
extends Button

signal deletion_requested(item)

func _pressed() -> void:
	emit_signal("pressed", self)


func _on_DeleteItemButton_pressed() -> void:
	emit_signal("deletion_requested", self)
