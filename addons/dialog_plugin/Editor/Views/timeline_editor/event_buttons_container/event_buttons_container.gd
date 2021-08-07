tool
extends HBoxContainer

signal event_pressed(event)

const Category = preload("res://addons/dialog_plugin/Editor/Views/timeline_editor/event_buttons_container/events_category/events_category_scene.gd")

var category_scene:PackedScene = load("res://addons/dialog_plugin/Editor/Views/timeline_editor/event_buttons_container/events_category/events_category_scene.tscn") as PackedScene

func _ready() -> void:
	var edited_scene = get_tree().edited_scene_root
	if edited_scene:
		if edited_scene.is_a_parent_of(owner) or edited_scene == owner:
			return
	generate_event_buttons()

func remove_all_childs():
	for child in get_children():
		child.queue_free()


func generate_event_buttons():
	remove_all_childs()
	# character_event, logic_event, miscelaneous_event, text_event
	var groups:Dictionary = _get_event_groups()
	var character_events:PoolStringArray = PoolStringArray(groups["character_event"])
	var logic_events:PoolStringArray = PoolStringArray(groups["logic_event"])
	var miscelaneous_events:PoolStringArray = PoolStringArray(groups["miscelaneous_event"])
	var text_events:PoolStringArray = PoolStringArray(groups["text_event"])
	
	add_category("Text Events", text_events)
	add_category("Logic Events", logic_events)
	add_category("Character Events", character_events)
	add_category("Misc Events", miscelaneous_events)
	

func add_category(category_name:String, category_events:PoolStringArray) -> void:
	var category:Category = category_scene.instance() as Category
	var separator:Separator = VSeparator.new()
	category.name = category_name
	category.category_name = category_name
	category.category_events = category_events
	category.connect("event_button_pressed", self, "_on_Category_event_button_pressed")
	category.connect("ready", category, "call_deferred", ["generate_buttons_from_events"])
	add_child(category)
	add_child(separator)
	

func _get_event_groups() -> Dictionary:
	var settings:ConfigFile = ConfigFile.new()
	settings.load("project.godot")
	var keys:PoolStringArray = settings.get_section_keys("textalog")
	var groups:Dictionary = {}
	for event_property in keys:
		# events/{base}/{class} -> String (Script path)
		event_property = event_property as String
		var sections = event_property.split("/")
		var _base:String = sections[1]
		var _class:String = sections[2]
		if not _base in groups:
			groups[_base] = []
		groups[_base].append("textalog/"+event_property)
	return groups


func _on_Category_event_button_pressed(event:DialogEventResource) -> void:
	if not event:
		return
	emit_signal("event_pressed", event)
