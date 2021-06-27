tool
# class_name <your_event_class_name_here>
extends DialogEventResource

# - - - - - - - - - -
# Base class for all dialog events
# - - - - - - - - - -
# You can read more about this class in the Documentation
# https://anidemdex.gitbook.io/godot-dialog-plugin/documentation/resource-class/class_dialog-event-resource


func _init()%VOID_RETURN%:
	# Uncomment resource_name line if you want to display a name in the editor
	#resource_name = "<your_event_name>"

	# Uncomment event_editor_scene_path line and replace it with your custom DialogEditorEventNode scene
	#event_editor_scene_path = "res://path/to/your/editor/node/scene.tscn"

	# Uncomment skip line if you want your event jump directly to next event 
	# at finish or not (false by default)
	#skip = false
	pass

func execute(caller:DialogBaseNode)%VOID_RETURN%:
	# Your event code go here

	# Notify that you end this event with finish()
	finish()
