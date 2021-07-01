tool
extends VBoxContainer

signal save

var options:Dictionary
var old_option:String
var option:String setget _set_option


func _on_LineEdit_text_entered(new_text: String) -> void:
	pass


func _set_option(value:String) -> void:
	option = value
	old_option = value
