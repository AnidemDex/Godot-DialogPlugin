tool
extends "res://addons/dialog_plugin/Nodes/editor_event_nodes/character_event/character_event_node_template.gd"

#base_resource:DialogCharacterJoinEvent

export(NodePath) var PreviewNode_path:NodePath
export(NodePath) var XLabel_path:NodePath
export(NodePath) var YLabel_path:NodePath
export(NodePath) var XSlider_path:NodePath
export(NodePath) var YSlider_path:NodePath
export(NodePath) var FlipH_Path:NodePath
export(NodePath) var FlipV_Path:NodePath
export(NodePath) var Rotation_Path:NodePath

# There's an issue when extending other tool scripts:
# If you extend a Node tool script, its parent _ready is called first
# that's no a problem, but if you had onready variables defined in
# child script that depends on variables defined on that child script,
# an error will appear in the console and the script can't get the values 
# No idea how to report that in godotengine/godot

# For now, i have to define it explicitly in _ready
onready var preview_node:DialogPortraitManager = get_node(PreviewNode_path) as DialogPortraitManager

onready var x_label:Label = get_node(XLabel_path) as Label
onready var y_label:Label = get_node(YLabel_path) as Label
onready var x_slider:Range = get_node(XSlider_path) as Range
onready var y_slider:Range = get_node(YSlider_path) as Range
onready var flip_h_node:Button = get_node(FlipH_Path) as Button
onready var flip_v_node:Button = get_node(FlipV_Path) as Button
onready var rotation_node:Range = get_node(Rotation_Path) as Range

var _reference_node:ReferenceRect

func _ready() -> void:
	# I really need to report that issue
	if get_tree().edited_scene_root == self:
		return
	
	_reference_node = preview_node.get_node_or_null("ReferenceSize")
	
	if base_resource:
		emit_signal("timeline_requested", self)

func _update_node_values():
	._update_node_values()
	
	var _relative_position = Vector2(base_resource.percent_position_x, base_resource.percent_position_y)
	var _rotation = base_resource.rotation
	var _position = preview_node._get_relative_position(_relative_position)
	
	x_label.text = str(stepify(_relative_position.x*100, 0.01))+"%"
	y_label.text = str(stepify(_relative_position.y*100, 0.01))+"%"
	
	x_slider.value = _relative_position.x
	y_slider.value = _relative_position.y
	
	flip_h_node.pressed = base_resource.flip_h
	flip_v_node.pressed = base_resource.flip_v
	
	rotation_node.value = base_resource.rotation
	
	if _reference_node:
		_reference_node.rect_position = _position
	
	preview_node.remove_all_portraits()
	preview_node.add_portrait(
		base_resource.character,
		base_resource.get_selected_portrait(),
		_relative_position,
		_rotation,
		base_resource.flip_h,
		base_resource.flip_v
		)


func _on_YSlider_value_changed(value: float) -> void:
	base_resource.percent_position_y = value
	_save_resource()
	_update_node_values()


func _on_XSlider_value_changed(value: float) -> void:
	base_resource.percent_position_x = value
	_save_resource()
	_update_node_values()


func _on_Reset_pressed() -> void:
	base_resource.percent_position_x = 0.414
	base_resource.percent_position_y = 0.275
	base_resource.rotation = 0
	_save_resource()
	_update_node_values()


func _on_Rotation_value_changed(value: float) -> void:
	base_resource.rotation = value
	_save_resource()
	_update_node_values()


func _on_FlipVertical_toggled(button_pressed: bool) -> void:
	base_resource.flip_v = button_pressed
	_save_resource()
	_update_node_values()


func _on_FlipHorizontal_toggled(button_pressed: bool) -> void:
	base_resource.flip_h = button_pressed
	_save_resource()
	_update_node_values()
