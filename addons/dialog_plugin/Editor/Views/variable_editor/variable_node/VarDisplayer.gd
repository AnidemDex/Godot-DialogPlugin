tool
extends PanelContainer

signal variable_value_modified(new_value)

var variable_node:Control
var _original_value
var _modified_value

func generate_displayer(for_value) -> void:
	_original_value = for_value
	_modified_value = for_value
	
	if variable_node:
		variable_node.queue_free()
	
	var _node = {
		TYPE_BOOL:"_get_checkbox_node",
		TYPE_INT:"_get_spinbox_node",
		TYPE_REAL:"_get_spinbox_node",
		TYPE_STRING:"_get_lineedit_node",
	}
	
	var _val_type = typeof(_original_value)
	variable_node = call(_node.get(_val_type, "_get_lineedit_node"))
	variable_node.connect("focus_exited", self, "_on_VariableNode_focus_exited")

	add_child(variable_node)
	
	match _val_type:
		TYPE_BOOL:
			variable_node.pressed = _original_value
		TYPE_INT,TYPE_REAL:
			variable_node.value = _original_value
		_:
			variable_node.text = str(_original_value)


func _get_lineedit_node() -> LineEdit:
	var _node:LineEdit = LineEdit.new()
	_node.connect("text_changed", self, "_on_VariableNode_text_changed")
	_node.connect("text_entered", self, "_on_VariableNode_text_entered")
	return _node


func _get_checkbox_node() -> CheckBox:
	var _node:CheckBox = CheckBox.new()
	_node.connect("toggled", self, "_on_VariableNode_toggled")
	return _node


func _get_spinbox_node() -> SpinBox:
	var _node:SpinBox = SpinBox.new()
	_node.allow_greater = true
	_node.allow_lesser = true
	if typeof(_original_value) == TYPE_REAL:
		_node.step = 0.01
	_node.connect("value_changed", self, "_on_VariableNode_value_changed")
	_node.get_line_edit().connect("focus_exited", self, "_on_VariableNode_focus_exited")
	return _node



func _on_VariableNode_text_changed(new_text: String) -> void:
	_modified_value = new_text


func _on_VariableNode_text_entered(_new_text:String) -> void:
	variable_node.release_focus()


func _on_VariableNode_toggled(button_press: bool) -> void:
	_modified_value = button_press


func _on_VariableNode_value_changed(value: float) -> void:
	if typeof(_original_value) == TYPE_REAL:
		_modified_value = value
	else:
		_modified_value = int(value)


func _on_VariableNode_focus_exited() -> void:
	# format it before emit signal
	# Lo que hice fue forzar a solo usar arrays, numeros y strings
	var DialogUtil := load("res://addons/dialog_plugin/Core/DialogUtil.gd")
	if typeof(_original_value)==TYPE_NIL:
		var _regex = RegEx.new()
		_regex.compile("^\\({1}|\\){1}$")
		if _regex.search_all(_modified_value).size() > 0:
			_modified_value = "'{0}'".format([_modified_value])
		if not DialogUtil.can_evaluate(_modified_value):
			_modified_value = "'{0}'".format([_modified_value])
		
		_modified_value = DialogUtil.evaluate(_modified_value)
	
	emit_signal("variable_value_modified", _modified_value)
