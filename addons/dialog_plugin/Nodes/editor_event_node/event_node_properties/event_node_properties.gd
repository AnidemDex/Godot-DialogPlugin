tool
extends PanelContainer

const CONDITION = PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_SCRIPT_VARIABLE
const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")

var EditorCheckButton:PackedScene = preload("res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/bool_property/check_button.tscn") as PackedScene

var SimpleTextEdit:PackedScene = load("res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/string_property/multiline/simple_textedit/text_edit.tscn")
var AdvancedTextEdit:PackedScene = load("res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/string_property/multiline/advanced_textedit/text_edit.tscn")
var LineEditScene:PackedScene = load("res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/string_property/singleline/line_edit.tscn")

var ResourceSelector:PackedScene = load("res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/resource_property/resource_selector.tscn")
var CharacterSelector:PackedScene = load("res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/resource_property/character_selector/character_selector.tscn")
var TimelineSelector:PackedScene = load("res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/resource_property/timeline_selector/timeline_selector.tscn")

export(NodePath) var PropertiesContainer_path:NodePath

var base_resource:DialogEventResource

var properties_generated:bool = false

onready var properties_container:Container = get_node(PropertiesContainer_path) as Container
onready var panel_stylebox:StyleBoxFlat = get_stylebox("panel")

func update_node_values() -> void:
	print_debug("Updating properties")
	if not properties_generated and base_resource:
		generate_properties()


func generate_properties() -> void:
	remove_all_childs()
	for property in base_resource.get_property_list():
		var required_condition:bool = bool(property["usage"] & CONDITION == CONDITION)
		if required_condition:
			generate_property_for(property)
	properties_generated = true


func generate_property_for(property:Dictionary) -> void:
	# {name, type, hint, hint_string, usage}
	var property_name:String = property.get("name", "")
	var property_type:int = property.get("type", TYPE_NIL)
	var property_hint:int = property.get("hint", PROPERTY_HINT_NONE)
	var property_hint_string:String = property.get("hint_string", "")
	var property_usage:int = property.get("usage", PROPERTY_USAGE_NOEDITOR)
	
	var property_node:Node = null
	
	match property_type:
		TYPE_BOOL:
			property_node = _get_bool_node_for(property)
		TYPE_STRING:
			property_node = _get_string_node_for(property)
		TYPE_OBJECT:
			if property_hint == PROPERTY_HINT_RESOURCE_TYPE:
				property_node = _get_resource_node_for(property)
		TYPE_INT, TYPE_REAL:
			property_node = _get_numeric_node_for(property)
	
	if not property_node:
		var error:String = "There's no node for this property: {0} - Type: {1}".format([property_name, property_type])
		push_error(error)
		DialogUtil.Logger.print_debug(base_resource, error)
		return
	
	property_node.set("base_resource", base_resource)
	property_node.set("used_property", property_name)
	properties_container.call_deferred("add_child", property_node)


func remove_all_childs() -> void:
	for child in get_children():
		if child == properties_container or child.is_a_parent_of(properties_container):
			continue
		child.queue_free()


func _after_expand() -> void:
	if base_resource:
		panel_stylebox.bg_color = base_resource.event_color

func _after_collapse() -> void:
	if base_resource:
		panel_stylebox.bg_color = Color("999999")


func _get_alternative_scene_for(property_name:String) -> PackedScene:
	return base_resource.get(property_name+"_alternative_node")


func _get_bool_node_for(property:Dictionary) -> Node:
	var property_name:String = property.get("name", "")
	var property_type:int = property.get("type", TYPE_NIL)
	var property_hint:int = property.get("hint", PROPERTY_HINT_NONE)
	var property_hint_string:String = property.get("hint_string", "")
	var property_usage:int = property.get("usage", PROPERTY_USAGE_NOEDITOR)
	
	var check_button:CheckButton
	
	var alternative_scene:PackedScene = _get_alternative_scene_for(property_name)
	if alternative_scene:
		check_button = alternative_scene.instance() as CheckButton
	else:
		check_button = EditorCheckButton.instance() as CheckButton
		
	var alternative_name:String = str(base_resource.get(property_name + "_alternative_name"))
	alternative_name = alternative_name if alternative_name != str(null) else property_name.capitalize()
	check_button.set("text", alternative_name)
	return check_button


func _get_string_node_for(property:Dictionary) -> Node:
	
	var property_name:String = property.get("name", "")
	var property_type:int = property.get("type", TYPE_NIL)
	var property_hint:int = property.get("hint", PROPERTY_HINT_NONE)
	var property_hint_string:String = property.get("hint_string", "")
	var property_usage:int = property.get("usage", PROPERTY_USAGE_NOEDITOR)
	
	var string_node:Node = null
	
	var alternative_scene:PackedScene = _get_alternative_scene_for(property_name)
	if alternative_scene:
		return alternative_scene.instance()
	
	if property_hint == PROPERTY_HINT_MULTILINE_TEXT:
		var use_complex_node = base_resource.get(property_name+"_use_complex_instead")
		if use_complex_node:
			string_node = AdvancedTextEdit.instance() as Control
		else:
			string_node = SimpleTextEdit.instance() as TextEdit
	else:
		string_node = LineEditScene.instance() as Control
	
	return string_node


func _get_resource_node_for(property:Dictionary) -> Node:
	
	var property_name:String = property.get("name", "")
	var property_type:int = property.get("type", TYPE_NIL)
	var property_hint:int = property.get("hint", PROPERTY_HINT_NONE)
	var property_hint_string:String = property.get("hint_string", "")
	var property_usage:int = property.get("usage", PROPERTY_USAGE_NOEDITOR)
	
	var resource_selector:Node = null
	resource_selector = ResourceSelector.instance() as Control
	
	var filters:PoolStringArray
	match property_hint_string:
		"DialogCharacterResource":
			filters = PoolStringArray(["*.tres"])
			if resource_selector:
				resource_selector.free()
			resource_selector = CharacterSelector.instance()
		"DialogTimelineResource":
			if resource_selector:
				resource_selector.free()
			resource_selector = TimelineSelector.instance()
		"":
			filters = PoolStringArray([])
		_:
			filters = ResourceLoader.get_recognized_extensions_for_type(property_hint_string)
	if resource_selector:
		resource_selector.set("filters", filters)
		resource_selector.set("hint_tooltip", property_name.capitalize())
	
	return resource_selector


func _get_numeric_node_for(property:Dictionary) -> Node:
	var NumericProperty:PackedScene = preload("res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/numeric_property/numeric_property.tscn")
	
	var property_name:String = property.get("name", "")
	var property_type:int = property.get("type", TYPE_NIL)
	var property_hint:int = property.get("hint", PROPERTY_HINT_NONE)
	var property_hint_string:String = property.get("hint_string", "")
	var property_usage:int = property.get("usage", PROPERTY_USAGE_NOEDITOR)
	
	var numeric_node:Node = NumericProperty.instance()
	if property_type == TYPE_REAL:
		numeric_node.set("step", 0.01)
	return numeric_node
