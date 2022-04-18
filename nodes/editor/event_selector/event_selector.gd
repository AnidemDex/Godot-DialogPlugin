tool
extends ConfirmationDialog

signal event_selected(event, timeline_path)

var tree:Tree
var root:TreeItem

var last_selected_item = null
var external_path:String = ""
var used_timeline:Resource = null

func _notification(what):
	if what == NOTIFICATION_POPUP_HIDE:
		if not visible:
			set_deferred("external_path", "")
			set_deferred("used_timeline", null)

func build_timeline(timeline) -> void:
	external_path = ""
	if root:
		root.free()
	
	tree = $VBoxContainer/Tree
	root = tree.create_item()
	root.set_text(0, "Timeline")
	root.disable_folding = true
	get_ok().disabled = true
	
	for event in timeline.get_events():
		var item:TreeItem = tree.create_item(root)
		item.set_text(0, str(event.get("event_name")))
		item.set_icon(0, event.get("event_icon"))
		item.set_meta("event", event)
	
	used_timeline = timeline


func get_selected_event() -> Resource:
	var item:TreeItem = tree.get_selected()
	var selected_event:Resource = null
	
	if item.has_meta("event"):
		selected_event = item.get_meta("event")
	
	return selected_event


func _on_Tree_item_selected():
	get_ok().disabled = false
	
	if last_selected_item == get_selected_event():
		_on_Tree_item_double_clicked()
		return
	
	last_selected_item = get_selected_event()


func _on_Tree_item_double_clicked():
	get_ok().grab_click_focus()


func _on_ConfirmationDialog_confirmed():
	var event = get_selected_event()
	var events:Array = used_timeline.get_events()
	var event_idx = events.find(event)
	
	emit_signal("event_selected", event_idx, external_path)


func _on_External_pressed():
	if Engine.editor_hint:
		var popup:EditorFileDialog = EditorFileDialog.new()
		popup.display_mode = EditorFileDialog.DISPLAY_LIST
		popup.mode = EditorFileDialog.MODE_OPEN_FILE
		popup.add_filter("*.tres; Timeline")
		popup.connect("file_selected", self, "_on_external_file_selected")
		
		add_child(popup)
		popup.popup_exclusive = true
		popup.popup_centered_ratio()


const TimelineClass = preload("res://addons/event_system_plugin/resources/timeline_class/timeline_class.gd")
func _on_external_file_selected(path:String) -> void:
	var res:TimelineClass = load(path) as TimelineClass
	if not res:
		push_warning("Invalid resource!")
		return
	
	build_timeline(res)
	external_path = path
