tool
extends Resource
class_name DialogCharacterResource

export(String) var name:String = "" setget ,_get_name
export(String) var display_name:String setget ,_get_display_name
export(Color) var color:Color = Color.white
export(Texture) var icon:Texture = null
export(AudioStream) var blip_sound:AudioStream = null
# Array of DialogPortraitResource
var portraits = PortraitArray.new() setget _set_portraits

func _get_name() -> String:
	if name == "":
		name = resource_path.get_file().replace("."+resource_path.get_extension(),"")
		resource_name = name
		
	return name

func _get_display_name() -> String:
	if display_name:
		return display_name
	else:
		return name

func get_good_name(with_name:String="") -> String:
	var _good_name = with_name
	
	if self.display_name:
		return self.display_name
	else:
		if _good_name.begins_with("res://"):
			_good_name = _good_name.replace("res://", "")
		if _good_name.ends_with(".tres"):
			_good_name = _good_name.replace(".tres", "")
		_good_name = _good_name.capitalize()
		return _good_name


func _set_portraits(value) -> void:
	portraits = value
	if not value:
		portraits = PortraitArray.new()


func _get_property_list() -> Array:
	var properties:Array = []
	properties.append(
		{
			"name":"portraits_number",
			"type":TYPE_INT,
			"hint":PROPERTY_HINT_NONE,
			"usage":PROPERTY_USAGE_NO_INSTANCE_STATE | PROPERTY_USAGE_EDITOR,
		}
	)
	properties.append(
		{
			"name":"portraits",
			"type":TYPE_OBJECT,
			"hint":PROPERTY_HINT_RESOURCE_TYPE,
			"usage":PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_NOEDITOR
		}
	)
	return properties

func _get(property: String):
	if property == "portraits_number":
		return portraits.get_resources().size()
