tool
extends TextEdit

var _DialogResources := load("res://addons/dialog_plugin/Core/DialogResources.gd")
var _variables:Dictionary = load(_DialogResources.DEFAULT_VARIABLES_PATH).get_original_variables()

func _on_TextEdit_text_changed() -> void:
	var regex = RegEx.new()
	regex.compile("{(\\w+)}")
	var _search_result:Array = regex.search_all(text)
	var _results = PoolStringArray([])
	for _result in _search_result:
		_results.append(_result.strings[1])
	var _intersect = []
	
	for i in _results:
		if i in _variables.keys():
			_intersect.append(i)
	
	if  _search_result and _intersect:
		add_color_region("{", "}", Color.greenyellow, false)
	else:
		clear_colors()
