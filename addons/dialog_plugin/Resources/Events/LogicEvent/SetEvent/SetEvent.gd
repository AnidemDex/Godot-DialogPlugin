tool
# class_name <your_event_class_name_here>
extends "res://addons/dialog_plugin/Resources/EventResource.gd"

export(String) var variable_name:String = ""
export(String) var variable_value:String = ""

func _init() -> void:
	# Uncomment resource_name line if you want to display a name in the editor
	resource_name = "SetVariableEvent"

	# Uncomment event_editor_scene_path line and replace it with your custom DialogEditorEventNode scene
	event_editor_scene_path = "res://addons/dialog_plugin/Nodes/editor_event_nodes/set_event_node/set_event_node.tscn"

	# Uncomment skip line if you want your event jump directly to next event 
	# at finish or not (false by default)
	skip = true


func execute(caller:DialogBaseNode) -> void:
	# Try to convert variable.name to variable:name in case using object
	variable_name = variable_name.replace(".", ":")
	# Load variables resource
	var _variable_resource = load(VARIABLES_PATH)
	var _variables:Dictionary = _variable_resource.variables
	var _variable_properties_to_modify:Array = Array(variable_name.split(":"))
	var _variable_name:String = _variable_properties_to_modify[0]
	
	var _variable = _variables.get(_variable_name, NAN)
	
	match typeof(_variable):
		TYPE_OBJECT:
			var property_path = NodePath(variable_name)
			_variable.set_indexed(property_path.get_concatenated_subnames(), variable_value)

		TYPE_REAL:
			if is_nan(_variable):
				push_warning("La variable que intentabas modificar no existe, la añadiremos a las variables.")
			continue
		_:
			_variable_resource.set_value(_variable_name, variable_value)
			
	finish()
