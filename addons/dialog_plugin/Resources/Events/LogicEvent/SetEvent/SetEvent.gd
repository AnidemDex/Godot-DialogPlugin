tool
class_name _DialogSetEvent
extends DialogLogicEvent

export(String) var variable_name:String = "" setget set_var_name
export(String) var variable_value:String = "" setget set_var_value

func _init() -> void:
	# Uncomment resource_name line if you want to display a name in the editor
	resource_name = "SetVariableEvent"
	event_name = "Set Variable"
	event_color = Color("#FBB13C")
	event_icon = load("res://addons/dialog_plugin/assets/Images/icons/event_icons/logic/set_variable.png") as Texture
	event_preview_string = "Set [ {variable_name} ] to be [ {variable_value} ]"

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


func set_var_name(value:String) -> void:
	variable_name = value
	emit_changed()
	property_list_changed_notify()


func set_var_value(value:String) -> void:
	variable_value = value
	emit_changed()
	property_list_changed_notify()


func _get(property: String):
	if property == "skip_disabled":
		return true
