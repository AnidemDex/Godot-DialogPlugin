extends Container
class_name OptionsManager

## Emmited when an option is selected
signal option_selected(option)
## Emmited when an option is added
signal option_added(option_button)

## Option button scene used
var OptionButtonScene:PackedScene = load("res://addons/textalog/nodes/dialogue_base_node/options_node/option_button/option_button.tscn")

## Adds an option and display it inmediatly to scene
func add_option(option:String) -> void:
	var option_button:Button = OptionButtonScene.instance() as Button
	option_button.connect("ready", self, "emit_signal", ["option_added", option_button])
	option_button.connect("pressed", self, "_on_OptionButton_pressed", [option])
	option_button.text = option
	add_child(option_button)


func _on_OptionButton_pressed(option:String) -> void:
	remove_options()
	emit_signal("option_selected", option)


## Removes all option buttons in scene
func remove_options() -> void:
	for child in get_children():
		child.queue_free()
