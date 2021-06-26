extends Timer

var caller:DialogBaseNode = null

func _input(event: InputEvent) -> void:
	if not caller.next_input:
		return
	if event.is_action_pressed(caller.next_input):
		(caller.DialogNode.TextNode as RichTextLabel).visible_characters = (caller.DialogNode.TextNode as RichTextLabel).get_total_character_count()
