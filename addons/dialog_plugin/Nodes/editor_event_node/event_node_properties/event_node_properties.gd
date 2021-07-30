tool
extends PanelContainer

const CONDITION = PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_SCRIPT_VARIABLE
const EditorCheckButton = preload("res://addons/dialog_plugin/Nodes/editor_event_node/event_property_nodes/bool_property/check_button.tscn")
const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")

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
			var check_button:CheckButton = EditorCheckButton.instance() as CheckButton
			var alternative_name:String = str(base_resource.get(property_name + "_alternative_name"))
			alternative_name = alternative_name if alternative_name != str(null) else property_name.capitalize()
			property_node = check_button
			check_button.set("text", alternative_name)
	
	if not property_node:
		DialogUtil.Logger.print_debug(base_resource,"There's no node for this property: {0}".format([property_name]))
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
