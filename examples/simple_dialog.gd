extends Node

# Here is described how you can make a simple dialog in screen
# You can attach this script to any node

func _ready() -> void:
	# First, we create the DialogNode instance.
	var dialog_node := DialogNode.new()
	
	# Now, we add it as child of the current node in order to make it
	# able to work normally
	add_child(dialog_node)
	
	# By default, DialogNode will be small. So we'll resize it with code.
	# Notice that if you make it child of a Node2D type, you will
	# need to set it's rect_size manually
	dialog_node.rect_size = Vector2(254, 64)
	
	# Finally, we just show the text
	dialog_node.show_text("Hello everybody!!!")
