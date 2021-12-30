extends Control

onready var background = $Background
onready var background_transitions = $BackgroundTransitions
onready var screencap = $Screencap
onready var dialog_manager = $DialogNode.dialog_manager
onready var event_manager = $EventManager
onready var ic_logs = $ICLogs

var bgs = [
	"res://examples/VisualNovel/Backgrounds/backgroundColorForest.png",
	"res://examples/VisualNovel/Backgrounds/backgroundColorGrass.png",
]
var bg_index = 0

var current_portrait: Portrait
var current_event: Event
var seen_events: Dictionary = {}

var skip_timer = 0.0

export var skip_delay: float = 0.02

func _process(delta):
	skip_timer += delta
	var go = Input.is_action_just_pressed("ui_accept") or Input.is_action_pressed("ui_right")
	if go and skip_timer > skip_delay:
		skip_timer = 0.0
		if not current_event:
			event_manager.go_to_next_event()
		elif event_manager.timeline in seen_events and \
			 current_event in seen_events[event_manager.timeline]:
				dialog_manager.display_all_text()

	if Input.is_action_just_pressed("ui_down"):
		bg_index = (bg_index + 1) % bgs.size()
		set_background(bgs[bg_index], 0, 0)


func set_background(bg_path: String, smooth: float = 0.5, speed: float = 1.0):
	var img = load(bg_path)
	if speed > 0:
		screencap.material.set_shader_param("smooth_size", smooth)
		var screen_img = get_tree().get_root().get_texture().get_data()
		screen_img.flip_y()
		var texture = ImageTexture.new()
		texture.create_from_image(screen_img)
		screencap.texture = texture
		yield(get_tree(), "idle_frame")
		background_transitions.play("transition", -1, speed)
	background.set_texture(img)


func _on_EventManager_event_started(event: Event):
	current_event = event


func _on_EventManager_event_finished(event: Event):
	current_event = null
	if event_manager.timeline in seen_events:
		if not (event in seen_events[event_manager.timeline]):
			seen_events[event_manager.timeline].append(event)
	else:
		seen_events[event_manager.timeline] = [event]
	if event is EventDialogText:
		var texture
		if event.character and current_portrait and current_portrait.icon:
			texture = ImageTexture.new()
			texture.create_from_image(current_portrait.icon.get_data())
		ic_logs.add_piece(texture, event.display_name, event.text)


func _on_DialogNode_portrait_added(_character, portrait):
	current_portrait = portrait


func _on_DialogNode_portrait_changed(_character, portrait):
	current_portrait = portrait


func _on_DialogNode_portrait_removed(_character):
	current_portrait = null


