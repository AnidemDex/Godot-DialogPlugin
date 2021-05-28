extends EditorProperty

const TimelinePicker = preload("res://addons/dialog_plugin/Nodes/editor_dialog_inspector/dialog_timeline_inspector.tscn")

var timeline_picker:OptionButton

func _init() -> void:
	label = "Timeline"
	timeline_picker = TimelinePicker.instance()
	timeline_picker.connect("item_selected", self, "_on_TimelinePicker_item_selected")
	add_child(timeline_picker)
	add_focusable(timeline_picker)

func update_property() -> void:
	var _value = get_edited_object()[get_edited_property()]
	timeline_picker.select_item_by_resource_path(_value)

func _on_TimelinePicker_item_selected(index: int) -> void:
	var _timeline_path = timeline_picker.get_item_metadata(index)
	emit_changed(get_edited_property(), _timeline_path)
