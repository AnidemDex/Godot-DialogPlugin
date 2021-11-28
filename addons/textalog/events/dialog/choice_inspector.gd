extends EditorInspectorPlugin

class OptionProperty extends EditorProperty:
	var selector:BaseButton
	var remover:BaseButton
	
	var hbox:HBoxContainer
	
	var undo_redo:UndoRedo
	
	func _init() -> void:
		hbox = HBoxContainer.new()
		add_child(hbox)
		
		selector = Button.new()
		selector.connect("pressed", self, "_on_Selector_pressed")
		selector.size_flags_horizontal = SIZE_EXPAND_FILL
		hbox.add_child(selector)
		add_focusable(selector)
		
		remover = Button.new()
		remover.connect("pressed", self, "_on_Remove_pressed")
		hbox.add_child(remover)
	
	
	func _ready() -> void:
		selector.icon = get_icon("Edit", "EditorIcons")
		selector.text = "Edit this option"
		
		remover.icon = get_icon("Remove", "EditorIcons")
	
	
	func _get_minimum_size() -> Vector2:
		return Vector2(24,24)
	
	
	func _on_Remove_pressed() -> void:
		var option = get_edited_property().replace("options/", "")
		var current_value = get_edited_object()[get_edited_property()]
		
		undo_redo.create_action("Remove option: %s"%option)
		undo_redo.add_do_method(get_edited_object(), "remove_option", option)
		undo_redo.add_undo_method(get_edited_object(), "set", get_edited_property(), current_value)
		undo_redo.commit_action()
	
	
	func _on_Selector_pressed() -> void:
#		emit_signal("object_id_selected", get_edited_property(), get_edited_object().get_instance_id())
		emit_signal("resource_selected", get_edited_property(), get_edited_object()[get_edited_property()])


class OptionAdder extends PanelContainer:
	var hbox:HBoxContainer
	var text_editor:LineEdit
	var add_btn:BaseButton
	
	var edited_object:Object
	
	var undo_redo:UndoRedo
	
	func _init() -> void:
		hbox = HBoxContainer.new()
		add_child(hbox)
		
		text_editor = LineEdit.new()
		text_editor.clear_button_enabled = true
		text_editor.placeholder_text = "New Option..."
		text_editor.size_flags_horizontal = SIZE_EXPAND_FILL
		text_editor.connect("text_entered", self, "_on_Add_pressed")
		hbox.add_child(text_editor)
		
		add_btn = Button.new()
		add_btn.text = "Add option"
		add_btn.connect("pressed", self, "_on_Add_pressed")
		hbox.add_child(add_btn)
	
	
	func _ready() -> void:
		add_btn.icon = get_icon("Add", "EditorIcons")
		add_stylebox_override("panel", get_stylebox("Background", "EditorStyles"))
	
	
	func _get_minimum_size() -> Vector2:
		return Vector2(24,24)
	
	
	func _on_Add_pressed(_l="") -> void:
		var option := text_editor.text.to_lower()
		
		if option == "":
			return
		
		undo_redo.create_action("Add Option: %s"%option)
		undo_redo.add_do_method(edited_object, "add_option", option)
		undo_redo.add_undo_method(edited_object, "remove_option", option)
		undo_redo.add_do_method(text_editor, "clear")
		undo_redo.add_undo_method(text_editor, "set_text", option)
		undo_redo.commit_action()


const InspectorTools = preload("res://addons/textalog/core/inspector_tools.gd")

var plugin_script:EditorPlugin
var editor_inspector:EditorInspector
var editor_gui:Control

var ObjClass = load("res://addons/textalog/events/dialog/choice.gd")

func can_handle(object: Object) -> bool:
	return object is ObjClass

func parse_begin(object: Object) -> void:
	var custom_category := InspectorTools.InspectorCategory.new()
	custom_category.label = "OptionTool"
	custom_category.icon = editor_gui.get_icon("Tools", "EditorIcons")
	custom_category.bg_color = editor_gui.get_color("prop_category", "Editor")
	
	add_custom_control(custom_category)
	
	var custom_control:OptionAdder = OptionAdder.new()
	custom_control.edited_object = object
	custom_control.undo_redo = plugin_script.get_undo_redo()
	add_custom_control(custom_control)
		


func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	if path.begins_with("options/"):
		var option_property = OptionProperty.new()
		option_property.undo_redo = plugin_script.get_undo_redo()
		add_property_editor(path, option_property)
		
		return true
	return false
