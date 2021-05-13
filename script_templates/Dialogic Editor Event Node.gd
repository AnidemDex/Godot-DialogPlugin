tool
extends DialogEditorEventNode

## Use _save_resource() method everywhere you update the base_resource
## properties. Then, call again _update_node_values if you want

func _ready()%VOID_RETURN%:
	# ALWAYS verify if you had a base_resource
	if base_resource:
        # You can prepare your nodes here before updating its values
		_update_node_values()

func _update_node_values()%VOID_RETURN%:
    pass # Update your nodes values here


