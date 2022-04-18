tool

class InspectorCategory extends Control:
	var icon:Texture
	var label:String
	var bg_color:Color = Color.black
	
	func _draw() -> void:
		draw_rect(Rect2(Vector2(), rect_size), bg_color)
		
		var font:Font = get_font("font", "Tree")
		
		var hs:int = get_constant("hseparation", "Tree");
		var w:int = font.get_string_size(label).x;
		if (icon):
			w += hs + icon.get_width();
		
		var ofs:int = (rect_size.x - w) / 2
		
		if (icon):
			draw_texture(icon, Vector2(ofs, (rect_size.y - icon.get_height()) / 2).floor())
			ofs += hs + icon.get_width();
		
		var color:Color = get_color("font_color", "Tree")
		draw_string(font, Vector2(ofs, font.get_ascent() + (rect_size.y - font.get_height()) / 2).floor(), label, color, rect_size.x);
	
	func _get_minimum_size() -> Vector2:
		var font:Font = get_font("font", "Tree")

		var ms:Vector2 = Vector2()
		ms.x = 1;
		ms.y = font.get_height()
		if icon:
			ms.y = max(icon.get_height(), ms.y);
		ms.y += get_constant("vseparation", "Tree");

		return ms;
	
	func _ready() -> void:
		var parent = get_parent()
		if is_instance_valid(parent):
			if get_position_in_parent() != 0:
				var category := parent.get_child(get_position_in_parent()-1) as Control
				category.hide()
		
		if icon == null:
			icon = get_icon("Object", "EditorIcons")
			update()
		
		if bg_color == Color.black:
			bg_color = get_color("prop_category", "Editor")
			update()


class InspectorEventSelector extends EditorProperty:
	var event_selector:Button
	var popup:ConfirmationDialog
	var reset_button:Button
	var updating:bool = false
	func _init() -> void:
		event_selector = Button.new()
		event_selector.text = "Select event"
		event_selector.connect("pressed",self,"_on_button_pressed")
		event_selector.size_flags_horizontal = SIZE_EXPAND_FILL
		
		reset_button = Button.new()
		reset_button.connect("pressed", self, "_on_reset_pressed")
		
		var hb = HBoxContainer.new()
		add_child(hb)
		hb.add_child(event_selector)
		hb.add_child(reset_button)
		
		popup = load("res://addons/event_system_plugin/nodes/editor/event_selector/event_selector.tscn").instance()
		popup.connect("event_selected", self, "_on_event_selected")
		add_child(popup)
	
	func _ready():
		reset_button.icon = get_icon("Remove", "EditorIcons")
		update_property()
	
	
	func update_property():
		var data:Array = str(get_edited_object()[get_edited_property()]).split(";", false)
		if data.empty():
			return
		
		var event_idx = data[0]
		var timeline_path = ""
		if data.size() >= 2:
			timeline_path = data[1]
		
		var timeline = null
		if timeline_path != "":
			timeline = load(timeline_path)
		
		if not timeline:
			timeline = Engine.get_meta("EventSystem").timeline_editor._edited_sequence
		
		if not timeline:
			return
		
		var event = timeline.get("event/"+event_idx)
		updating = true
		if event:
			event_selector.text = event.get("event_name")
		updating = false
		
	
	func _on_button_pressed() -> void:
		var timeline = Engine.get_meta("EventSystem").timeline_editor._edited_sequence
		if timeline:
			popup.build_timeline(timeline)
			popup.call_deferred("popup_centered_ratio", 0.45)
	
	
	func _on_event_selected(event_idx, path) -> void:
		if updating:
			return
		var value = "{idx};{path}".format({"idx":event_idx, "path":path})
		emit_changed(get_edited_property(), value)
	
	func _on_reset_pressed() -> void:
		if updating:
			return
		
		emit_changed(get_edited_property(), null)
