class_name DialogOptionsManager
extends Container

signal option_selected(option)

var OptionButtonScene:PackedScene = load("res://addons/dialog_plugin/Nodes/option_button/option_button.tscn")

func add_option(option:String) -> void:
	var option_button:Button = OptionButtonScene.instance() as Button
	option_button.connect("pressed", self, "_on_OptionButton_pressed", [option])
	option_button.connect("pressed", self, "remove_options")
	option_button.text = option
	add_child(option_button)


func _on_OptionButton_pressed(option:String) -> void:
	emit_signal("option_selected", option)


func remove_options() -> void:
	for child in get_children():
		child.queue_free()
