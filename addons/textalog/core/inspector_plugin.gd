tool
extends EditorInspectorPlugin

const _DialogNode = preload("res://addons/textalog/nodes/dialogue_base_node/dialog_node.gd")
const _BlipData = preload("res://addons/textalog/resources/blip_data.gd")

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


var last_category:String = ""
func can_handle(object: Object) -> bool:
	return object is _BlipData


func parse_category(object: Object, category: String) -> void:
	last_category = category
	
	if object is _BlipData and category == "Map Samples":
		var toolbar := BlipToolbar.new()
		toolbar.blip_data = object
		add_custom_control(toolbar)
		return


func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	if object is _BlipData and last_category == "Map Samples":
		add_property_editor(path, BlipProperty.new())
		return true
	return false
