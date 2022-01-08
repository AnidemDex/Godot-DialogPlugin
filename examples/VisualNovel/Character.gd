extends Control


export var main_node: NodePath
export var expression_player: NodePath
export var talk_player: NodePath

var texture

func _ready():
	set_size(get_node(main_node).get_rect().size)
	if is_connected("resized", self, "_on_resized"):
		return
	connect("resized", self, "_on_resized")


func _on_resized():
	if not main_node:
		push_warning("Main Node not defined on %" % self)
		return
	var node = get_node(main_node)
	var size = node.get_rect().size
	node.set_scale(Vector2(rect_size.y/size.y, rect_size.y/size.y))
	node.position.x = (rect_size.x - size.x*node.scale.x)/2


func change_expression(expression: String):
	if not expression_player:
		push_warning("Expression Player not defined on %" % self)
		return
	var anim_player = get_node(expression_player)
	anim_player.play(expression)


func set_talk(toggle: bool):
	if not talk_player:
		push_warning("Talk Player not defined on %" % self)
		return
	var anim_player = get_node(talk_player)
	if toggle:
		anim_player.play("talk")
	else:
		anim_player.play("RESET")
