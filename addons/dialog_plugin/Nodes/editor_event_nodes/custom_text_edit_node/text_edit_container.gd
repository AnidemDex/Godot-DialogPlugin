tool
extends PanelContainer

signal text_changed(new_text)

export(NodePath) var TextEdit_path:NodePath

onready var text_edit_node:TextEdit = get_node(TextEdit_path) as TextEdit

func insert_bbcode(bbcode:String) -> void:
	var selected_text:String = get_selected_text()
	var formatted_text = get_formatted_text_with_bbcode(selected_text, bbcode)
	
	text_edit_node.insert_text_at_cursor(formatted_text)


func get_selected_text() -> String:
	return text_edit_node.get_selection_text()


func get_text_in_line(line_number:int) -> String:
	return text_edit_node.get_line(line_number)


func get_caret_column() -> int:
	return text_edit_node.cursor_get_column()


func get_caret_line() -> int:
	return text_edit_node.cursor_get_line()


func get_bbcode_tag_from(bbcode:String) -> String:
	return bbcode.split(" ")[0]


func get_formatted_text_with_bbcode(text:String, bbcode:String) -> String:
	var bbcode_tag:String = get_bbcode_tag_from(bbcode)
	var bbcode_format:String = "[{bbcode}]{text}[/{bbcode_end}]"
	var meta:Dictionary = {"bbcode":bbcode, "text":text, "bbcode_end":bbcode_tag}
	return bbcode_format.format(meta)


func set_text(text:String) -> void:
	text_edit_node.text = text


func get_text() -> String:
	return text_edit_node.text


func _on_LinkButton_pressed() -> void:
	OS.shell_open("https://docs.godotengine.org/en/stable/tutorials/gui/bbcode_in_richtextlabel.html")


func _on_TextEdit_text_changed() -> void:
	emit_signal("text_changed", get_text())
