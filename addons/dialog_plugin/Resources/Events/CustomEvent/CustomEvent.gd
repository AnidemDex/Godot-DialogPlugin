tool
class_name DialogCustomEvent
extends DialogEventResource

var event_resource:DialogEventResource = null

func _init() -> void:
	# Uncomment resource_name line if you want to display a name in the editor
	resource_name = "CustomEvent"

	# Uncomment event_editor_scene_path line and replace it with your custom DialogEditorEventNode scene
	#event_editor_scene_path = "res://path/to/your/editor/node/scene.tscn"


func excecute(caller:DialogBaseNode) -> void:
	# Parent function must be called at the start
	.excecute(caller)
	
	if not event_resource:
		finish(true)
		return
	
	# Cyclic resource, must use load
	var _class = load("res://addons/dialog_plugin/Resources/Events/CustomEvent/CustomEvent.gd")
	if event_resource is _class or not(event_resource is DialogEventResource):
		finish(true)
		return

	var _err = (event_resource as DialogEventResource).connect("event_finished", self, "_on_CustomEvent_end")
	assert(_err == OK)
	event_resource.excecute(caller)

	# Notify that you end this event

func _on_CustomEvent_end(_event, _skip) -> void:
	finish(_skip)


func _get_property_list() -> Array:
	var properties:Array = []
	properties.append(
		{
			"name":"event_resource",
			"type":TYPE_OBJECT,
			"hint":PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string":"DialogEventResource",
		}
	)
	return properties
