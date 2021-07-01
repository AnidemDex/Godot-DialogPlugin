tool
extends "res://addons/dialog_plugin/Nodes/editor_event_nodes/text_event_node/text_event_node.gd"

# base_resource:DialogTextWithAudioEvent

export(NodePath) var BlipButton_path:NodePath
export(NodePath) var BlipLoop_path:NodePath
export(NodePath) var BlipForce_path:NodePath

onready var blip_loop_node:CheckBox = get_node(BlipLoop_path) as CheckBox
onready var blip_force_node:CheckBox = get_node(BlipForce_path) as CheckBox

func _ready() -> void:
	if base_resource:
		emit_signal("timeline_requested", self)


func _update_node_values():
	._update_node_values()
	update_node_blip_button()
	update_node_blip_loop()
	update_node_force_blip()


func update_node_blip_button() -> void:
	pass


func update_node_blip_loop() -> void:
	if not is_instance_valid(blip_loop_node):
		return
	base_resource = base_resource as DialogTextWithAudioEvent
	blip_loop_node.pressed = base_resource.loop_blip_sound


func update_node_force_blip() -> void:
	if not is_instance_valid(blip_force_node):
		return
	base_resource = base_resource as DialogTextWithAudioEvent
	blip_force_node.pressed = base_resource.force_blip_sound


func _on_LoopBlip_toggled(button_pressed: bool) -> void:
	base_resource.set("loop_blip_sound", button_pressed)
	_save_resource()


func _on_ForceBlip_toggled(button_pressed: bool) -> void:
	base_resource.set("force_blip_sound", button_pressed)
	_save_resource()