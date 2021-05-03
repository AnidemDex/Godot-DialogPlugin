tool
class_name DialogTextEvent
extends DialogEventResource


var EventTimer = load("res://addons/dialog_plugin/Resources/Events/TextEvent/TextEventTimer.gd")

export(String, MULTILINE) var text:String = ""
export(Resource) var character = DialogCharacterResource.new()

var _timer = null
var _DialogNode:DialogDialogueNode = null

func _init():
	resource_name = "TextEvent"


func excecute(caller:DialogBaseNode) -> void:
	.excecute(caller)
	
	_caller = caller
	_DialogNode = caller.DialogNode
	
	if not _timer or not(is_instance_valid(_timer)):
		_timer = EventTimer.new()
		_timer.caller = _caller
		_caller.add_child(_timer)
	if not _timer.is_connected("timeout", self, "_on_TextTimer_timeout"):
		var _err = _timer.connect("timeout", self, "_on_TextTimer_timeout")
		assert(_err == OK)

	caller.visible = true
	if _DialogNode:
		_DialogNode.visible = true
	
	_update_text()
	
	if not character.name:
		# Default speaker should be displayed here
		character = DialogCharacterResource.new()

	_update_name()


func _update_text() -> void:
	if _DialogNode:
		_DialogNode.TextNode.bbcode_text = text
		_DialogNode.TextNode.visible_characters = 0
		_timer.start(_DialogNode.text_speed)


func _update_name() -> void:
	if _DialogNode:
		if _DialogNode.NameNode:
			if not character.name:
				_DialogNode.NameNode.visible = false
			else:
				_DialogNode.NameNode.visible = true
			_DialogNode.NameNode.text = character.display_name
			_DialogNode.NameNode.set('custom_colors/font_color', character.color)


func _on_TextTimer_timeout():
	_DialogNode.TextNode.visible_characters += 1
	if _DialogNode.TextNode.visible_characters < _DialogNode.TextNode.get_total_character_count():
		_timer.start(_DialogNode.text_speed)
	else:
		if is_instance_valid(_timer):
			_timer.stop()
			_timer.queue_free()
		finish()


func get_event_editor_node() -> DialogEditorEventNode:
	var _scene_resource:PackedScene = load("res://addons/dialog_plugin/Nodes/editor_event_nodes/text_event_node/text_event_node.tscn")
	_scene_resource.resource_local_to_scene = true
	var _instance = _scene_resource.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
	_instance.base_resource = self
	return _instance
