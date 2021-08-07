tool
extends Button

signal resource_selected(resource)

export(PoolStringArray) var filters:PoolStringArray = PoolStringArray([])

var popup_reference:Popup

func _pressed() -> void:
	if Engine.editor_hint:
		var file_dialog:EditorFileDialog = EditorFileDialog.new()
		popup_reference = file_dialog
		for filter in filters:
			file_dialog.add_filter(filter)
		file_dialog.mode = EditorFileDialog.MODE_OPEN_FILE

	else:
		var file_dialog:FileDialog = FileDialog.new()
		popup_reference = file_dialog
		file_dialog.filters = filters
		file_dialog.mode = FileDialog.MODE_OPEN_FILE
		
	popup_reference.connect("file_selected", self, "_on_FileEditor_file_selected")
	popup_reference.connect("popup_hide", popup_reference, "queue_free")
	add_child(popup_reference)
	
	popup_reference.popup_centered_ratio()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			emit_signal("resource_selected", null)
			text = "[None]"


func _on_FileEditor_file_selected(file_path:String) -> void:
	text = file_path.get_file()
	emit_signal("resource_selected", load(file_path))
