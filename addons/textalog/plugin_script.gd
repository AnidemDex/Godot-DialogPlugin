tool
extends "godot_plugin.gd"

const PLUGIN_NAME = "Textalog"

# Hardcoded paths because is not a good idea to rely on
# scanning directories for now

var event_scripts := PoolStringArray([
	"res://addons/textalog/events/dialog/text.gd",
	"res://addons/textalog/events/dialog/choice.gd",
	"res://addons/textalog/events/character/change_expression.gd",
	"res://addons/textalog/events/character/join.gd",
	"res://addons/textalog/events/character/leave.gd",
])

func _enter_tree() -> void:
	show_plugin_version_button()


func _enable_plugin() -> void:
	var main_panel:Container = load("res://addons/textalog/nodes/editor/welcome/main_panel.tscn").instance()
	var dialog_system_info = load("res://addons/textalog/nodes/editor/welcome/dialog_system_info.tscn").instance()
	var popup:WelcomeNode = get_plugin_welcome_node()
	popup.get_tab_container().add_child(dialog_system_info)
	popup.get_tab_container().move_child(dialog_system_info, 1)
	get_plugin_welcome_node().get_tab_by_idx(0).add_child(main_panel)
	
	show_welcome_node()
