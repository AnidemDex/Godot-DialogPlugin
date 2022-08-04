tool
extends Resource

const _SPACE_AND_SCAPE = "__SPACE_AND_ESCAPE_CHARACTERS__"

var _data := []
var _map_data := {}
var _generator := RandomNumberGenerator.new()

func add_audio(audio:AudioStream) -> void:
	if audio == null:
		push_error("add_audio: Can't add null value")
		return
	
	if not audio in _data:
		_data.append(audio)
		emit_changed()


func remove_audio(audio:String) -> void:
	_data.erase(audio)
	emit_changed()

func map(string:String) -> void:
	if string in _map_data:
		return
	
	_map_data[string] = []
	emit_changed()
	property_list_changed_notify()


func map_add(string:String, audio:AudioStream) -> void:
	var data:Array
	if not string in _map_data:
		map(string)
	
	data = _map_data[string]
	add_audio(audio)
	if audio != null:
		data.append(audio)
	_map_data[string] = data
	emit_changed()
	property_list_changed_notify()


func map_rename(string:String, to:String) -> void:
	var data = get_sample(string)
	if data:
		_map_data.erase(string)
		_map_data[to] = data
		emit_changed()


func get_sample(for_string:String) -> AudioStream:
	var sample:AudioStream
	var _samples:Array = _data
	
	if for_string in " " or for_string.strip_escapes().empty():
		_samples = _map_data.get(_SPACE_AND_SCAPE, [])
	elif for_string in _map_data:
		_samples = _map_data.get(for_string, [])
	
	if _samples.empty():
		return null
	
	var _limit:int = max(_samples.size()-1, 0)
	
	sample = _samples[_generator.randi_range(0, _limit)] as AudioStream
	
	return sample


func _set(property: String, value) -> bool:
	if property == "samples":
		_data = value.duplicate()
		property_list_changed_notify()
		return true
	
	if property == _SPACE_AND_SCAPE and typeof(value) == TYPE_ARRAY:
		_map_data[_SPACE_AND_SCAPE] = value
		emit_changed()
		return true
	
	if property in _map_data:
		if typeof(value) == TYPE_ARRAY:
			if value.empty():
				_map_data.erase(property)
				emit_changed()
				property_list_changed_notify()
				return true
			
			_map_data[property] = value
			emit_changed()
			property_list_changed_notify()
			return true
	
	return false


func _get(property: String):
	if property == "samples":
		return _data
	
	if property == _SPACE_AND_SCAPE:
		return _map_data[_SPACE_AND_SCAPE]
	
	if property in _map_data:
		return _map_data[property]


func _hide_script_from_inspector():
	return true


func _init() -> void:
	_data = []
	_map_data = {_SPACE_AND_SCAPE: []}
	_generator.randomize()


func _get_property_list() -> Array:
	var p := []
	p.append({"name":"Blip Data", "type":TYPE_NIL, "usage":PROPERTY_USAGE_CATEGORY})
	p.append({"name":"samples", "type":TYPE_ARRAY, "hint":24, "hint_string":"17/17:AudioStream", "usage":PROPERTY_USAGE_DEFAULT})
	p.append({"name":"Map Samples", "type":TYPE_NIL, "usage":PROPERTY_USAGE_CATEGORY})
	p.append({"name":_SPACE_AND_SCAPE, "type":TYPE_ARRAY, "hint":24, "hint_string":"17/17:AudioStream", "usage":PROPERTY_USAGE_DEFAULT})
	for key in _map_data:
		if key == _SPACE_AND_SCAPE:
			continue
		p.append({"name":key, "type":TYPE_ARRAY, "hint":24, "hint_string":"17/17:AudioStream", "usage":PROPERTY_USAGE_DEFAULT})
	
	return p
