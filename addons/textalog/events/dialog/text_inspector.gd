extends EditorInspectorPlugin

var ObjClass = load("res://addons/textalog/events/dialog/text.gd")

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


func can_handle(object: Object) -> bool:
	return object is ObjClass


func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	if type == TYPE_ARRAY and path == "audio_sounds":
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
	
	return false
