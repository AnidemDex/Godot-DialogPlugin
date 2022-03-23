tool
extends PanelContainer

class TitleBar extends PanelContainer:
	signal toggled(pressed)
	
	var bar:HBoxContainer
	var collapse_button:CheckBox
	
	func _gui_input(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.is_pressed():
			collapse_button.grab_focus()
			collapse_button.grab_click_focus()
	
	
	func _toggle(button_pressed:bool) -> void:
		emit_signal("toggled", button_pressed)
	
	
	func _enter_tree() -> void:
		collapse_button.add_icon_override("unchecked", get_icon("Forward", "EditorIcons"))
		collapse_button.add_icon_override("checked", get_icon("Collapse", "EditorIcons"))
		add_stylebox_override("panel", get_stylebox("panel_odd", "TabContainer"))
	
	
	func _init() -> void:
		bar = HBoxContainer.new()
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bar.focus_mode = Control.FOCUS_NONE
		bar.size_flags_horizontal = SIZE_EXPAND_FILL
		bar.size_flags_vertical = SIZE_EXPAND_FILL
		bar.rect_clip_content = true
		
		collapse_button = CheckBox.new()
		collapse_button.set_pressed_no_signal(true)
		bar.add_child(collapse_button)
		add_child(bar)
		
		collapse_button.connect("toggled", self, "_toggle")
	
	
	func generate_previews(for_these_events:Array) -> void:
		for child in bar.get_children():
			if child == collapse_button:
				continue
			child.queue_free()
		
		var holder = HBoxContainer.new()
		holder.focus_mode = Control.FOCUS_NONE
		holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bar.add_child(holder)
		for event in for_these_events:
			var t_node := TextureRect.new()
			t_node.focus_mode = Control.FOCUS_NONE
			t_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
			t_node.rect_min_size = Vector2(16,16)
			t_node.expand = true
			t_node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			t_node.texture = event.get("event_icon") as Texture
			holder.add_child(t_node)


var unfolded_container:TabContainer
var body:VBoxContainer
var title_bar:TitleBar
var preview:Resource

func add_timeline_and_get_node(timeline:Resource) -> Control:
	var TimelineDisplayer = load("res://addons/event_system_plugin/nodes/editor/timeline_displayer.gd")
	var timeline_displayer:Control = TimelineDisplayer.new()
	unfolded_container.add_child(timeline_displayer)
	
	if not preview:
		preview = timeline
	
	if unfolded_container.get_child_count() > 1:
		unfolded_container.tabs_visible = true
	
	timeline_displayer.set("last_used_timeline", timeline)
	timeline_displayer.call_deferred("load_timeline", timeline)
	timeline.connect("changed", timeline_displayer, "reload")
	return timeline_displayer


func  _set_subtimeline_visible(_visible:bool) -> void:
	unfolded_container.visible = _visible
	
	var events := []
	if not _visible:
		events = preview.get_events()
	title_bar.generate_previews(events)


func _enter_tree() -> void:
	body.add_constant_override("separation", 0)


func _init() -> void:
	name = "SubtimelineContainer"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	focus_mode = Control.FOCUS_NONE
	
	unfolded_container = TabContainer.new()
	title_bar = TitleBar.new()
	body = VBoxContainer.new()
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	body.add_child(title_bar)
	body.add_child(unfolded_container)
	add_child(body)
	
	unfolded_container.tabs_visible = false
	
	title_bar.connect("toggled", self, "_set_subtimeline_visible")
