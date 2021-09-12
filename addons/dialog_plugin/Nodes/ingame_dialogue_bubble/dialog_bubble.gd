extends DialogBaseNode

func _ready() -> void:
	_set_nodes_default_values()
	if autostart:
		start_timeline()
