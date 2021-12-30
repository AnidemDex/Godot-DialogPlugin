extends Node

# Here is described how you can make a simple dialog in screen
# You can attach this script to any node

func _ready() -> void:
	# First, we create the DialogNode instance.
	# We don't use new() because we need the scene, not the base class
	var dialog_node := DialogNode.instance()
	
	# Now, we add it as child of the current node in order to make it
	# able to work normally
	
	# By default, DialogNode will take the whole screen as its rect_size.
	# Notice that if you make it child of a Node2D type, you will
	# need to set it's rect_size manually
	add_child(dialog_node)
	
	# Finally, we just show the text
	dialog_node.show_text("Hello everybody!!!")
