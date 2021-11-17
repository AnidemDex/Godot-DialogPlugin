tool
extends EditorPlugin

const PLUGIN_NAME = "Textalog"

var _welcome_scene:PackedScene = load("res://addons/textalog/nodes/editor/welcome/hi.tscn")

var _plugin_data := ConfigFile.new()
var _version_button:BaseButton


func get_plugin_version() -> String:
	var _version = _plugin_data.get_value("plugin","version", "0")
	return _version


func _enter_tree() -> void:
	_add_version_button()


func enable_plugin() -> void:
	_show_welcome()


func _add_version_button() -> void:
	var _v = {"version":get_plugin_version()}
	_version_button = ToolButton.new()
	connect("tree_exiting", _version_button, "free")
	_version_button.text = "TaL:[{version}]".format(_v)
	_version_button.hint_tooltip = "Textalog version {version}".format(_v)
	var _new_color = _version_button.get_color("font_color")
	_new_color.a = 0.6
	_version_button.add_color_override("font_color", _new_color)
	_version_button.size_flags_horizontal = Control.SIZE_SHRINK_END|Control.SIZE_EXPAND
	_version_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	var _dummy := Control.new()
	var _dock_button := add_control_to_bottom_panel(_dummy, "dummy")
	_dock_button.get_parent().add_child(_version_button)
	remove_control_from_bottom_panel(_dummy)
	_dummy.free()


func _show_welcome() -> void:
	var _popup:Popup = _welcome_scene.instance() as Popup
	_popup.connect("ready", _popup, "popup_centered_ratio", [0.4])
	_popup.connect("popup_hide", _popup, "queue_free")
	_popup.connect("hide", _popup, "queue_free")
	get_editor_interface().get_base_control().add_child(_popup)


func _init() -> void:
	name = PLUGIN_NAME.capitalize()
	_plugin_data.load("res://addons/textalog/plugin.cfg")
