tool
extends EditorInspectorPlugin

const _DialogNode = preload("res://addons/textalog/nodes/dialog_node.gd")
const _BlipData = preload("res://addons/textalog/resources/blip_data.gd")
const _Character = preload("res://addons/textalog/resources/character_class/character_class.gd")

class BlipToolbar extends HBoxContainer:
	var blip_data
	var lineedit:LineEdit
	var add_btn:Button
	
	func map_string() -> void:
		var string:String = lineedit.text
		if string == "":
			return
		
		if typeof(blip_data.get(string)) == TYPE_ARRAY:
			lineedit.clear()
			return
		
		blip_data.map(string)
	
	func _enter_tree() -> void:
		add_btn.icon = get_icon("Add", "EditorIcons")
	
	func _init() -> void:
		size_flags_horizontal = SIZE_EXPAND_FILL
		
		lineedit = LineEdit.new()
		lineedit.placeholder_text = "Add a character to map audios to it"
		lineedit.size_flags_horizontal = SIZE_EXPAND_FILL
		add_child(lineedit)
		add_btn = Button.new()
		add_btn.text = "Add"
		add_btn.connect("pressed", self, "map_string")
		add_child(add_btn)


class BlipProperty extends EditorProperty:
	var items:ItemList
	var add_button:MenuButton
	var updating:bool = false
	
	func audio_selected(id:int) -> void:
		if updating:
			return
		
		var audio:AudioStream = get_edited_object().samples[id]
		var maped_data:Array = get_edited_object()[get_edited_property()]
		
		if not audio in maped_data:
			maped_data.append(audio)
			emit_changed(get_edited_property(), maped_data)
	
	
	func item_options(index:int, at_position:Vector2) -> void:
		if updating:
			return
		
		items.remove_item(index)
		var maped_data:Array = get_edited_object()[get_edited_property()]
		maped_data.remove(index)
		emit_changed(get_edited_property(), maped_data)
	
	
	func _enter_tree() -> void:
		add_button.icon = get_icon("Add", "EditorIcons")
	
	
	func update_property() -> void:
		updating = true
		var samples:Array = get_edited_object().samples
		var maped_data:Array = get_edited_object()[get_edited_property()]
		var icon = get_icon("AudioStreamSample", "EditorIcons")
		
		add_button.get_popup().clear()
		items.clear()
		
		for sample in samples:
			if sample:
				add_button.get_popup().add_icon_item(icon, sample.resource_path.get_file())
		
		for sample in maped_data:
			items.add_item(sample.resource_path.get_file(), icon)
		
		updating = false
	
	
	func _init() -> void:
		add_button = MenuButton.new()
		add_button.text = "Add Audio Sample"
		add_button.size_flags_horizontal = SIZE_EXPAND_FILL
		add_button.get_popup().allow_search = true
		add_button.get_popup().connect("id_pressed", self, "audio_selected")
		add_child(add_button)
		
		items = ItemList.new()
		items.auto_height = true
		items.allow_rmb_select = true
		items.hint_tooltip = "Right mouse click on a item to remove it"
		items.connect("item_rmb_selected", self, "item_options")
		add_child(items)
		set_bottom_editor(items)


class PortraitsDisplayer extends EditorProperty:
	
	class _ItemList extends ItemList:
		var edited_object:Object
		
		func _make_custom_tooltip(for_text: String) -> Control:
			var idx:int = get_item_at_position(get_local_mouse_position())
			if idx == -1:
				return null
			
			var portrait = get_item_metadata(idx)
			if not portrait:
				return null
			
			var style_box = get_stylebox("panel", "ProjectSettingsEditor")

			var panel = PanelContainer.new()
			var texture = TextureRect.new()
			var vb = VBoxContainer.new()
			var name := Label.new()
			var resolution := Label.new()
			
			vb.size_flags_horizontal = SIZE_EXPAND_FILL
			vb.size_flags_vertical = SIZE_EXPAND_FILL
			texture.texture = portrait.texture as Texture
			texture.expand = true
			texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			texture.rect_min_size = Vector2(128,254)
			panel.add_stylebox_override("panel", style_box)
			
			name.text = "[Empty]"
			if portrait.texture != null:
				name.text = portrait.texture.resource_path
				resolution.text = str(texture.texture.get_size())
			
			vb.add_child(name)
			vb.add_child(texture)
			vb.add_child(resolution)
			panel.add_child(vb)
			
			return panel
	
	var portrait_container:ItemList
	var _vb:VBoxContainer
	var add_button:Button
	
	func _init() -> void:
		_vb = VBoxContainer.new()
		
		portrait_container = _ItemList.new()
		portrait_container.rect_min_size = Vector2(0, 64)
		portrait_container.fixed_icon_size = Vector2(16,16)
		portrait_container.auto_height = true
		portrait_container.set_drag_forwarding(self)
		portrait_container.connect("item_selected", self, "_on_item_selected")
		portrait_container.connect("item_activated", self, "_on_item_activated")
		portrait_container.connect("gui_input", self, "_on_item_gui_input")
		
		add_button = Button.new()
		add_button.text = "Add single portrait"
		add_button.connect("pressed", self, "_on_add_button_pressed")
		
		_vb.add_child(add_button)
		_vb.add_child(portrait_container)
		add_child(_vb)
		set_bottom_editor(_vb)
	
	
	func update_property() -> void:
		var portraits:Array = get_edited_object().get("portraits")
		portrait_container.edited_object = get_edited_object()
		
		portrait_container.clear()
		for idx in portraits.size():
			var portrait_name:String = portraits[idx]
			var portrait = get_edited_object().get("portrait/"+portrait_name) as Portrait
			if portrait == null:
				continue
			
			portrait_container.add_item(portrait_name, portrait.icon)
			portrait_container.set_item_metadata(idx, portrait)
	
	
	func can_drop_data_fw(position: Vector2, data, _c) -> bool:
		if typeof(data) == TYPE_DICTIONARY:
			if data.has("type") and data["type"] == "files":
				return true
		return false
	
	
	func drop_data_fw(position: Vector2, data, _c) -> void:
		if not typeof(data) == TYPE_DICTIONARY:
			return
		var files:Array = data["files"]
		var new_portraits:Array = []
		var portraits:Array = get_edited_object()["portraits"]
		
		for file in files:
			file = file as String
			
			var image := load(file) as Texture
			var skip := false
			
			if image == null:
				continue
			
			for portrait in portraits:
				portrait = portrait as Portrait
				if portrait == null:
					continue
				
				if image == portrait.image:
					push_warning("The given texture '%s' is already added as '%s' portrait"%[file.get_file(), portrait.name])
					skip = true
					break
			
			if skip:
				continue
			
			var portrait := Portrait.new()
			portrait.image = image
			portrait.name = file.get_file()
			
			new_portraits.append(portrait)
		
		portraits.append_array(new_portraits)
		emit_changed(get_edited_property(), portraits.duplicate())
	
	
	func _on_item_gui_input(event: InputEvent) -> void:
		if event is InputEventKey:
			if event.scancode == KEY_DELETE:
				if portrait_container.is_anything_selected():
					var _idxs:Array = portrait_container.get_selected_items()
					var _portraits:Array = get_edited_object()[get_edited_property()].duplicate()
					for idx in _idxs:
						_portraits.remove(idx)
						portrait_container.remove_item(idx)
					
					emit_changed(get_edited_property(), _portraits)
					portrait_container.accept_event()
	
	
	func _on_item_selected(item_idx:int) -> void:
		pass
	
	
	func _on_item_activated(item_idx:int) -> void:
		var portrait = portrait_container.get_item_metadata(item_idx)
		if portrait:
			emit_signal("resource_selected", "", portrait)
	
	
	func _on_add_button_pressed() -> void:
		var character:Character = get_edited_object()
		var portrait:Portrait = Portrait.new()
		var portraits:PoolStringArray = get_edited_object()["portraits"]
		portrait.name = "New portrait "+str(portraits.size())


var last_category:String = ""
func can_handle(object: Object) -> bool:
	if object is _BlipData:
		return true
	
	if object is _Character:
		return true
	
	return false


func parse_category(object: Object, category: String) -> void:
	last_category = category
	
	if object is _BlipData and category == "Map Samples":
		var toolbar := BlipToolbar.new()
		toolbar.blip_data = object
		add_custom_control(toolbar)
		return
	
	if object is _Character and category == "Portraits":
		var editor := PortraitsDisplayer.new()
		add_property_editor_for_multiple_properties("Portratis", object.get("portraits"), editor)
		return


func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	if object is _BlipData and last_category == "Map Samples":
		add_property_editor(path, BlipProperty.new())
		return true
	
	if object is _Character and path.begins_with("portrait/"):
		return true
	
	return false
