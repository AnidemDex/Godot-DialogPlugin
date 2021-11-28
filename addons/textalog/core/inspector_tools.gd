tool
extends EditorInspector

class InspectorCategory extends Control:
	var icon:Texture
	var label:String
	var bg_color:Color
	
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
		
		if bg_color == null:
			bg_color = get_color("prop_category", "Editor")
			update()

func get_category_instance() -> InspectorCategory:
	return InspectorCategory.new()
