extends Control


var piece_res = preload("res://examples/VisualNovel/DialogPiece.tscn")

onready var scroll_container = $LogLayout/ScrollContainer
onready var piece_container = $LogLayout/ScrollContainer/PieceContainer
onready var log_layout = $LogLayout

export var duplicate_logging: bool = true

func clear():
	for piece in piece_container.get_children():
		piece.queue_free()


func add_piece(icon: Texture, showname: String, text: String):
	if not duplicate_logging:
		for piece in piece_container.get_children():
			var piece_name = piece.get_node("HBoxContainer/VBoxContainer/Name").text
			var piece_dialog = piece.get_node("HBoxContainer/VBoxContainer/Dialog").text
			if showname == piece_name and text == piece_dialog:
				# This is a duplicate - don't bother logging it
				return
	
	var piece: Control = piece_res.instance()
	piece.get_node("HBoxContainer/Avatar").texture = icon
	piece.get_node("HBoxContainer/VBoxContainer/Name").text = showname
	piece.get_node("HBoxContainer/VBoxContainer/Dialog").text = text
	piece_container.add_child(piece)
	yield(get_tree(), "idle_frame")
	scroll_container.ensure_control_visible(piece)


func filter_pieces(search: String):
	for piece in piece_container.get_children():
		var piece_name = piece.get_node("HBoxContainer/VBoxContainer/Name").text
		var piece_dialog = piece.get_node("HBoxContainer/VBoxContainer/Dialog").text

		piece.set_visible(false)
		if search == "" or piece_name.to_lower().find(search.to_lower()) != -1 \
			 or piece_dialog.to_lower().find(search.to_lower()) != -1:
			piece.set_visible(true)


func _on_SearchString_text_changed(new_text: String):
	filter_pieces(new_text)


func _on_Button_pressed():
	log_layout.set_visible(not log_layout.visible)
	if log_layout.visible:
		yield(get_tree(), "idle_frame")
		scroll_container.scroll_vertical = scroll_container.get_v_scrollbar().max_value
