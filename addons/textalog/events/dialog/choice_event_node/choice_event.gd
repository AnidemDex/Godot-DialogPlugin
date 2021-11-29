tool
extends "res://addons/event_system_plugin/nodes/editor/event_node/event_node.gd"

class OptionSelector extends VBoxContainer:
	signal option_selected
	
	var category:Label
	var timeline_button:Button
	var option:String = ""
	
	
	func _init() -> void:
		category = Label.new()
		category.size_flags_vertical = SIZE_EXPAND_FILL
		category.align = Label.ALIGN_CENTER
		add_child(category)
		
		timeline_button = Button.new()
		timeline_button.size_flags_vertical = SIZE_EXPAND_FILL
		timeline_button.connect("pressed", self, "emit_signal", ["option_selected"])
		
		add_child(timeline_button)
	
	func _ready() -> void:
		category.text = "Option %s"%option
		timeline_button.text = "Preview %s timeline"%option
		category.add_color_override("font_color", get_color("font_color", "Tree"))
		update()
	
	func _draw() -> void:
		var bg_color = get_color("prop_category", "Editor")
		draw_rect(Rect2(category.rect_position, category.rect_size), bg_color)
	

signal timeline_selected(timeline)

export(NodePath) var OptionContainer:NodePath

onready var options_container:Container = get_node(OptionContainer) as Container


func _draw_bottom_line() -> void:
	pass


func _update_values() -> void:
	._update_values()
	var options:Dictionary = event.get("options") as Dictionary
	if options == null:
		return
	
	var hint = "Available options:\n"
	
	for child in options_container.get_children():
		child.queue_free()
	
	for option in options:
		hint += "- %s\n"%option
		var option_button := OptionSelector.new()
		option_button.option = option
		option_button.size_flags_horizontal = SIZE_EXPAND_FILL
		option_button.rect_min_size = Vector2(32, 0)
		option_button.connect("option_selected", self, "emit_signal", ["timeline_selected", options[option]])
		options_container.add_child(option_button)
	
	_desc_container_node.hint_tooltip = hint


func _show_options() -> void:
	if not options_container:
		return
	options_container.show()


func _hide_options() -> void:
	if not options_container:
		return
	options_container.hide()


func _on_focus_enter() -> void:
	._on_focus_enter()
	_show_options()

func _on_global_focus_changed(node) -> void:
	if is_instance_valid(node):
		if not is_a_parent_of(node):
			_hide_options()
