extends Tree

var statement_icon = preload("res://addons/dialog_plugin/assets/Images/icons/timeline_icon.png")
var visible_icon = preload("res://addons/dialog_plugin/assets/Images/Pieces/GuiVisibilityVisible.svg")
var invisible_icon = preload("res://addons/dialog_plugin/assets/Images/Pieces/GuiVisibilityHidden.svg")

func _ready():
	var root = self.create_item()
	add_statement("Statement 1")
	add_statement("Statement 2")
	add_statement("Statement 3")
	add_statement("Statement 4")
	add_statement("Statement 5")

func add_statement(statement_name = "0"):
	var statement = create_item(get_root())
	statement.set_text(0, statement_name)
	statement.set_icon(0, statement_icon)
	statement.add_button(0, visible_icon, -1, false, "Toggle Visibility")
	return statement
