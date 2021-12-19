# All inspectors must be in a single script due to
# https://github.com/godotengine/godot/issues/55648
# May be splited in 3.5+

extends EditorInspectorPlugin

class DisplayNameProperty extends EditorProperty:
	var line_edit:LineEdit
	var updating:bool
	
	func _init() -> void:
		line_edit = LineEdit.new()
		line_edit.connect("text_changed", self, "_on_text_changed")
		line_edit.connect("text_entered", self, "_on_text_entered")
		
		add_child(line_edit)
		set_bottom_editor(line_edit)
		
		add_focusable(line_edit)
		
		updating = false
	
	
	func update_property() -> void:
		var actual_value:String = str(get_edited_object()[get_edited_property()])
		
		updating = true
		if line_edit.text != actual_value:
			line_edit.text = actual_value
			
		line_edit.editable = !read_only
		updating = false
	
	
	func _on_text_entered(new_text:String) -> void:
		if updating:
			return
		
		if line_edit.has_focus():
			line_edit.release_focus()
			_on_text_changed(new_text)
	
	
	func _on_text_changed(new_text:String) -> void:
		if updating:
			return
		
		emit_changed(get_edited_property(), new_text, "", true)


class TextProperty extends EditorProperty:
	var vb:VBoxContainer
	var text:TextEdit
	var big_text:TextEdit
	var big_text_dialog:AcceptDialog
	
	func _text_changed() -> void:
		emit_changed(get_edited_property(), text.text, "", true)
	
	
	func _init() -> void:
		vb = VBoxContainer.new()
		
		text = TextEdit.new()
		text.wrap_enabled = true
		text.size_flags_vertical = SIZE_EXPAND_FILL
		text.connect("text_changed", self, "_text_changed")
		add_focusable(text)
		
		var hb := HBoxContainer.new()
		# TODO: Add buttons to get shortcuts to bbcode tags
		var help_btn := LinkButton.new()
		help_btn.text = "More information"
		help_btn.underline = LinkButton.UNDERLINE_MODE_ON_HOVER
		help_btn.size_flags_horizontal = SIZE_SHRINK_END | SIZE_EXPAND
		help_btn.connect("pressed", self, "_on_HelpButton_pressed")
		
		hb.add_child(help_btn)
		
		vb.add_child(hb)
		vb.add_child(text)
		
		add_child(vb)
		set_bottom_editor(vb)
	
	
	func update_property() -> void:
		var actual_value:String = get_edited_object()[get_edited_property()]
		if (text.text != actual_value):
			text.text = actual_value
	
	
	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_ENTER_TREE, NOTIFICATION_THEME_CHANGED:
				var font = get_font("font","Label")
				text.rect_min_size = Vector2(0, font.get_height() * 6)
	
	
	func set_disabled(value:bool) -> void:
		read_only = value
		text.readonly = read_only
	
	
	func _on_HelpButton_pressed() -> void:
		OS.shell_open("https://docs.godotengine.org/en/stable/tutorials/gui/bbcode_in_richtextlabel.html")


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


class PortraitPreview extends PanelContainer:
	var p_m:PortraitManager
	var d_m:DialogManager
	var object:Resource

	func _init() -> void:
		p_m = PortraitManager.new()
		d_m = DialogManager.new()
		d_m.size_flags_vertical = SIZE_SHRINK_END
		d_m.text_autoscroll = false
		d_m.text_show_scroll_at_end = false
		d_m.disconnect("draw", d_m.text_node, "set")

		add_child(p_m)
		add_child(d_m)
		
		rect_clip_content = true
	
	func _ready() -> void:
		d_m.set_text("This is a placeholder.\nRectangle is just a visual reference.")
		d_m.display_text()
	
	
	func _on_event_changed() -> void:
		var rect_data := {
			"ignore_reference_size":object.get("rect_ignore_reference_size"),
			"ignore_reference_position":object.get("rect_ignore_reference_position"),
			"ignore_reference_rotation":object.get("rect_ignore_reference_rotation"),
			"size":object.get("rect_percent_size"),
			"position":object.get("rect_percent_position"),
			"rotation":object.get("rect_rotation")
		}
		var texture_data := {
			"expand":object.get("texture_expand"),
			"stretch_mode":object.get("texture_stretch_mode"),
			"flip_h":object.get("texture_flip_h"),
			"flip_v":object.get("texture_flip_v")
		}
		var chara = object.get("character")
		var portrait = object.call("get_selected_portrait")
		
		var args := [chara, portrait, rect_data, texture_data]
		
		if rect_data["ignore_reference_size"] or rect_data["ignore_reference_position"] or rect_data["ignore_reference_rotation"]:
			p_m.reference_rect.border_color = get_color("disabled_font_color", "Editor")
		else:
			p_m.reference_rect.border_color = get_color("warning_color", "Editor")
		
		p_m.remove_all_portraits()
		p_m.call_deferred("callv","add_portrait", args)
	
	
	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_RESIZED:
				_on_event_changed()


const InspectorTools = preload("res://addons/textalog/core/inspector_tools.gd")

var plugin_script:EditorPlugin
var editor_inspector:EditorInspector
var editor_gui:Control

var TextClass = load("res://addons/textalog/events/dialog/text.gd")
var ChoiceClass = load("res://addons/textalog/events/dialog/choice.gd")
var _JoinEvent = load("res://addons/textalog/events/character/join.gd")

func can_handle(object: Object) -> bool:

	if object is TextClass:
		return true
	
	if object is ChoiceClass:
		return true
	
	if object is _JoinEvent:
		return true
		
	return false


func parse_begin(object: Object) -> void:
	if object is ChoiceClass:
		var custom_category := InspectorTools.InspectorCategory.new()
		custom_category.label = "OptionTool"
		custom_category.icon = editor_gui.get_icon("Tools", "EditorIcons")
		custom_category.bg_color = editor_gui.get_color("prop_category", "Editor")
		add_custom_control(custom_category)
		
		var custom_control:OptionAdder = OptionAdder.new()
		custom_control.edited_object = object
		custom_control.undo_redo = plugin_script.get_undo_redo()
		add_custom_control(custom_control)
	
	if object is _JoinEvent:
		var custom_category := InspectorTools.InspectorCategory.new()
		custom_category.label = "Preview"
		custom_category.icon = editor_gui.get_icon("GuiVisibilityXray", "EditorIcons")
		custom_category.bg_color = editor_gui.get_color("prop_category", "Editor")
		add_custom_control(custom_category)

		var custom_control := PortraitPreview.new()
		custom_control.rect_min_size = Vector2(0, 254)
		custom_control.object = object
		object.connect("changed", custom_control, "_on_event_changed")
		add_custom_control(custom_control)


func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:

	if object is TextClass:
		if type == TYPE_ARRAY and path == "audio_blip_sounds":
			if object.get("audio_same_as_character"):
				return true
		
		if path == "display_name":
			var property_node := DisplayNameProperty.new()
			add_property_editor(path, property_node)
			return true
		
		if path == "text":
			var property_node := TextProperty.new()
			if object.get("translation_key"):
				property_node.set_disabled(true)
			add_property_editor(path, property_node)
			return true
	
	
	if object is ChoiceClass:
		if path.begins_with("options/"):
			var option_property = OptionProperty.new()
			option_property.undo_redo = plugin_script.get_undo_redo()
			add_property_editor(path, option_property)
		
			return true
	
	return false

