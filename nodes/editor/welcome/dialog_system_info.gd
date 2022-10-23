tool
extends VBoxContainer

const ENABLED_INFO = "Event System is enabled."
const DISABLED_INFO = "Event System is {status}. Press this button to {action}."

export(NodePath) var dialog_path:NodePath
export(NodePath) var status_path:NodePath
export(Array, NodePath) var events_path:Array

onready var status_button:Button = get_node(status_path) as Button
onready var dialog_node = get_node(dialog_path)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_VISIBILITY_CHANGED, NOTIFICATION_DRAW:
			if visible:
				update_status()


func update_status() -> void:
	var plugin = null
	
	var info = ""
	var hint = ""
	
	if Engine.has_meta("EventSystem"):
		plugin = Engine.get_meta("EventSystem")
		if is_instance_valid(plugin):
			plugin = plugin as EditorPlugin
	
	if not is_instance_valid(plugin):
		info = "Disabled"
		hint = DISABLED_INFO
		if Directory.new().dir_exists("res://addons/event_system_plugin"):
			hint = hint.format({"status":info.to_lower(), "action":"enable it"})
		else:
			info = "Not installed"
			hint = hint.format({"status":info.to_lower(), "action":"go to the download page"})
	else:
		info = "Enabled"
		hint = ENABLED_INFO
	
	if is_instance_valid(status_button):
		status_button.text = info
		status_button.hint_tooltip = hint


func _on_Status_pressed() -> void:
	match status_button.text:
		"Disabled":
			var plugin:EditorPlugin
			
			if Engine.has_meta("Textalog"):
				plugin = Engine.get_meta("Textalog")
				
			if Directory.new().dir_exists("res://addons/event_system_plugin"):
				if is_instance_valid(plugin):
					plugin.get_editor_interface().set_plugin_enabled("event_system_plugin", true)
					plugin.call_deferred("event_system_integration")
				get_tree().root.call_deferred("propagate_call","update")
				
		"Not Installed":
			OS.shell_open("https://github.com/AnidemDex/Godot-EventSystem")


func _on_EventShow_pressed() -> void:
	dialog_node.show()

var CharClass = preload("res://addons/textalog/resources/character_class/character_class.gd")
var PClass = preload("res://addons/textalog/resources/portrait_class/portrait_class.gd")
var chara = CharClass.new()
var pt = PClass.new()
func _on_EventJoin_pressed() -> void:
	chara.add_portrait("", pt)
	pt.texture = load("res://icon.png")
	chara.name = "icon.png"
	
	dialog_node.character_join(chara)


func _on_EventSay_pressed() -> void:
	dialog_node.call("show_text", "This is a little demo")

var steps = 0
var curr_step = -1
func _on_Play_pressed() -> void:
	steps = events_path.size()
	curr_step += 1
	if curr_step < steps:
		var node = get_node(events_path[curr_step])
		node.emit_signal("pressed")
		node.set("disabled", true)
		get_tree().create_timer(1).connect("timeout", self, "_on_Play_pressed")
	else:
		steps = 0
		curr_step = -1
		propagate_call("set", ["disabled", false])


func _on_GitHub_pressed() -> void:
	OS.shell_open("https://github.com/AnidemDex/Godot-EventSystem")
