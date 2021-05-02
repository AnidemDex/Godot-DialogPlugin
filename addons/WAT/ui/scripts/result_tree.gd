extends Tree
tool

const FUNCTION: Texture = preload("res://addons/WAT/assets/function.png")
const PASSED_ICON: Texture = preload("res://addons/WAT/assets/passed.png")
const FAILED_ICON: Texture = preload("res://addons/WAT/assets/failed.png")
const PASSED: Color = Color(0, 1, 0, 1)
const FAILED: Color = Color(1, 1, 1, 1)
signal calculated
var _cache: Array = []
var _mega_cache: Array = []
signal function_selected

func _ready():
	hide_root = true
	connect("button_pressed", self, "_on_button_pressed")

func goto_function(path: String, function: String) -> void:
	emit_signal("function_selected", path, function)
	
func _on_button_pressed(item, column, id):
	goto_function(item.get_meta("path"), item.get_meta("fullname"))

func display(cases: Array) -> void:
	var total = cases.size()
	var passed = 0
	var root = create_item()

	for c in cases:
		passed += c.success as int
		var script = create_item(root)
		script.set_text(0, "(%s/%s) %s" % [c.passed, c.total, c.context])
		script.set_custom_color(0, _color(c.success))
		script.set_icon(0, _icon(c.success))
		_cache.append(script)
		_mega_cache.append(script)
		
		for m in c.methods:
			var method = create_item(script)
			method.set_text(0, "%s" % m.context)
			method.set_custom_color(0, _color(m.success))
			method.set_icon(0, _icon(m.success))
			_cache.append(method)
			_mega_cache.append(method)
			method.add_button(0, FUNCTION)
			method.set_tooltip(0, "Click icon to show test method in editor")
			method.set_meta("path", c.path)
			method.set_meta("context", m.context)
			method.set_meta("fullname", m.fullname)

			for a in m.assertions:
				if a.context != "":
					method.collapsed = false
					var assertion = create_item(method)
					assertion.set_text(0, a.context)
					assertion.set_custom_color(0, _color(a.success))
					assertion.set_icon(0, _icon(a.success))
					assertion.collapsed = true
					_mega_cache.append(assertion)
					
					var expected = create_item(assertion)
					var actual = create_item(assertion)
					expected.set_text(0, "EXPECTED: %s" % a.expected)
					actual.set_text(0, "RESULTED: %s" % a.actual)
				else:
					method.collapsed = true
					var expected = create_item(method)
					var actual = create_item(method)
					expected.set_text(0, "EXPECTED: %s" % a.expected)
					actual.set_text(0, "RESULTED: %s" % a.actual)
				
	var success = total > 0 and total == passed
	root.set_text(0, "%s/%s" % [passed, total])
	root.set_custom_color(0, _color(success))
	root.set_icon(0, _icon(success))
	emit_signal("calculated", self, passed, total, success)
	
func _color(success: bool) -> Color:
	return PASSED if success else FAILED
	
func _icon(success: bool) -> Texture:
	return PASSED_ICON if success else FAILED_ICON
	
func expand_all() -> void:
	for item in _cache:
		item.collapsed = false
		
func collapse_all() -> void:
	for item in _cache:
		item.collapsed = true
		
func expand_failures() -> void:
	for item in _mega_cache:
		item.collapsed = true if item.get_icon(0) == PASSED_ICON else false
