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

var inspector = load("res://addons/textalog/core/inspector_plugin.gd").new()

func _enter_tree() -> void:
	var main_panel:Container = load("res://addons/textalog/nodes/editor/welcome/main_panel.tscn").instance()
	var dialog_system_info = load("res://addons/textalog/nodes/editor/welcome/dialog_system_info.tscn").instance()
	var popup:WelcomeNode = get_plugin_welcome_node()
	popup.get_tab_container().add_child(dialog_system_info)
	popup.get_tab_container().move_child(dialog_system_info, 1)
	get_plugin_welcome_node().get_tab_by_idx(0).add_child(main_panel)
	
	add_inspector_plugin(inspector)
	
	show_plugin_version_button()
	event_system_integration()


func _enable_plugin() -> void:
	show_welcome_node()


func _exit_tree() -> void:
	remove_inspector_plugin(inspector)


var registered_events:Resource
var events_inspector:EditorInspectorPlugin
func event_system_integration() -> void:
	var path := "res://addons/textalog/events/"
	var file := ".gdignore"
	
	if not get_editor_interface().is_plugin_enabled("event_system_plugin"):
		var _file := File.new()
		_file.open(path+file,File.WRITE)
		_file.close()
	else:
		var dir := Directory.new()
		if dir.file_exists(path+file):
			dir.remove(path+file)
		
		var r_e_path := "res://addons/event_system_plugin/resources/registered_events/registered_events.tres"
		registered_events = load(r_e_path)
		if registered_events:
			var events = []
			var current_events:Array = registered_events.call("get_events")
			var curr_evs_paths:PoolStringArray = PoolStringArray()
			
			for event in current_events:
				event = event as Resource
				if not event:
					continue
				
				curr_evs_paths.append(event.get_script().resource_path)
				
			for ev_path in event_scripts:
				if ev_path in curr_evs_paths:
					continue
				
				var ev = load(ev_path).new()
				events.append(ev)
			
			current_events.append_array(events)
			registered_events.call("set_events", current_events)
			
			events_inspector = load("res://addons/textalog/events/inspector.gd").new()
			events_inspector.set("plugin_script", self)
			events_inspector.set("editor_gui", get_editor_interface().get_base_control())
			add_inspector_plugin(events_inspector)
			connect("tree_exiting", self, "remove_inspector_plugin", [events_inspector])
			
	
	# Force re-scan
	var editor_interface:EditorInterface = get_editor_interface()
	editor_interface.get_resource_filesystem().call_deferred("scan")
	editor_interface.get_resource_filesystem().call_deferred("scan_sources")
	editor_interface.get_resource_filesystem().call_deferred("update_script_classes")
