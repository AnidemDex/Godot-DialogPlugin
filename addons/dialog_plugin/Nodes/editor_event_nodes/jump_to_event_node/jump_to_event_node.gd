tool
extends DialogEditorEventNode

## Use _save_resource() method everywhere you update the base_resource
## properties. Then, call again _update_node_values if you want

export(NodePath) var EventList_path:NodePath

onready var event_list_node:OptionButton = get_node(EventList_path) as OptionButton

func _ready() -> void:
	# ALWAYS verify if you had a base_resource
	if base_resource:
		# You can prepare your nodes here before updating its values
		event_list_node.generate_items()
		_update_node_values()

func _update_node_values() -> void:
	pass # Update your nodes values here




func _on_EventList_item_selected(index: int) -> void:
	if not base_resource:
		return
	
	if event_list_node.get_item_metadata(index):
		pass
	else:
		pass
	
	_save_resource()
