extends Node

# Here is described an alternative when you want to
# show dialogs in screen.
#
# Instead of creating the dialog node by code,
# we setup the dialog node in the scene.


func _ready() -> void:
	# First, we get the DialogNode instance.
	var dialog_node := $DialogNode
	
	# Then we just show the text
	dialog_node.show_text("Hello everybody!!!")
