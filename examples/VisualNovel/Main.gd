extends Control

var transition_shader = preload("res://examples/VisualNovel/transition.gdshader")

onready var background = $Background
onready var background_transitions = $BackgroundTransitions
onready var screencap = $Screencap
onready var dialog_node = $DialogNode
onready var event_manager = $EventManager
onready var ic_logs = $ICLogs
onready var music_player = $MusicPlayer

var bgs = [
	"res://examples/VisualNovel/Backgrounds/backgroundColorForest.png",
	"res://examples/VisualNovel/Backgrounds/backgroundColorGrass.png",
]
var bg_index = 0

var current_character: Character
var current_portrait: Portrait
var current_timeline: Timeline
var current_event: Event
var seen_events: Dictionary = {}

var skip_timer = 0.0

export var skip_delay: float = 0.02

func _process(delta):
	skip_timer += delta
	var go = Input.is_action_just_pressed("ui_accept") or Input.is_action_pressed("ui_right")
	if current_timeline and go and skip_timer > skip_delay:
		skip_timer = 0.0
		if not current_event:
			event_manager.go_to_next_event()
		elif event_manager.timeline in seen_events and \
			 current_event in seen_events[event_manager.timeline]:
				dialog_node.dialog_manager.display_all_text()

	if Input.is_action_just_pressed("ui_down"):
		bg_index = (bg_index + 1) % bgs.size()
		set_background(bgs[bg_index], 0, 0)


func set_music(mus_path: String):
	music_player.stream = load(mus_path)
	music_player.play()


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
	if event is EventDialogText:
		current_character = event.character
		if current_character:
			var node = dialog_node.portrait_manager.portraits[current_character]
			if node.has_method("set_talk"):
				node.set_talk(true)


func _on_EventManager_event_finished(event: Event):
	current_event = null
	var seen = false
	if event_manager.timeline in seen_events:
		if event in seen_events[event_manager.timeline]:
			seen = true
		else:
			seen_events[event_manager.timeline].append(event)
	else:
		seen_events[event_manager.timeline] = [event]

	if not seen and event is EventDialogText:
		var texture
		if event.character and current_portrait and current_portrait.icon:
			texture = ImageTexture.new()
			texture.create_from_image(current_portrait.icon.get_data())
		ic_logs.add_piece(texture, event.display_name, event.text)


func _on_DialogNode_portrait_added(character, portrait):
	current_portrait = portrait

	# TODO: move this to its own function for easy access + more customizability
	var shader_material = ShaderMaterial.new()
	shader_material.shader = transition_shader
	shader_material.set_shader_param("mask", load("res://examples/VisualNovel/transition3.png"))
	shader_material.set_shader_param("cutoff", 1.0)
	shader_material.set_shader_param("smooth_size", 0.5)
	var texture_rect = dialog_node.portrait_manager.portraits[character]
	texture_rect.material = shader_material
	var anim_player = $PortraitTemplate/AnimationPlayer.duplicate()
	anim_player.root_node = texture_rect.get_path()
	texture_rect.add_child(anim_player)
	anim_player.play("transition")


func _on_DialogNode_portrait_changed(character, portrait):
	current_portrait = portrait


func _on_DialogNode_portrait_removed(_character):
	current_portrait = null

func _on_Investigation_investigate(obj_name, timeline):
	event_manager.start_timeline(timeline)


func _on_EventManager_timeline_started(timeline_resource):
	current_timeline = timeline_resource


func _on_EventManager_timeline_finished(timeline_resource):
	current_timeline = null


func _on_DialogNode_text_displayed():
	if current_character:
		var node = dialog_node.portrait_manager.portraits[current_character]
		if node.has_method("set_talk"):
			node.set_talk(false)
