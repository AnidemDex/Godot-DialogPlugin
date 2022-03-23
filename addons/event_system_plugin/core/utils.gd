extends Reference

## Util function to get a dictionary of object property:value
static func get_property_values_from(object:Object) -> Dictionary:
	if object == null:
		return {}
	var dict = {}
	# Hope this doesn't freeze the engine per call
	for property in object.get_property_list():
		dict[property.name] = object.get(property.name)
	return dict


# Based on: https://www.askpython.com/python/built-in-methods/python-eval
## Evaluates an string, excecutes it and returns the result
static func evaluate(input:String, global:Object=null, locals:Dictionary={}, _show_error:bool=true):
	var _evaluated_value = null
	var _expression = Expression.new()
	
	var _err = _expression.parse(input, PoolStringArray(locals.keys()))
	
	if _err != OK:
		push_warning(_expression.get_error_text())
	else:
		_evaluated_value = _expression.execute(locals.values(), global, _show_error)
		
		if _expression.has_execute_failed():
			return input
		
	return _evaluated_value
