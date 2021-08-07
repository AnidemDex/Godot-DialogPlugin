tool
extends VBoxContainer

export(NodePath) var Icon_path:NodePath
export(NodePath) var LowBranch_path:NodePath

var base_resource:DialogEventResource = null

onready var lower_branch_node:Control = get_node(LowBranch_path) as Control
onready var icon_node:TextureRect = get_node(Icon_path) as TextureRect

func update_node_values() -> void:
	lower_branch_node.update()
	icon_node.texture = base_resource.event_icon if base_resource else null


func _on_LowerBranch_draw() -> void:
	if not base_resource:
		return
	var branch_disabled = base_resource.get("branch_disabled")
	if branch_disabled:
		return
	var used_color:Color = Color.black
	var line_width:float = 4.0
	var height:float = lower_branch_node.rect_size.y
	var width:float = lower_branch_node.rect_size.x
	var middle_position:Vector2 = Vector2(width/2,0)
	var end_position = Vector2(0, height) + middle_position
	var _skip:bool = base_resource.skip
	
	if _skip:
		var relative_height:float = height-12
		var arrow:PoolVector2Array = PoolVector2Array([Vector2(width/2, height), Vector2(lerp(0, width, 0.2), relative_height), Vector2(lerp(0, width, 0.8), relative_height)])
		end_position = Vector2(0, relative_height) + middle_position
		used_color = Color("#FBB13C")
		lower_branch_node.draw_colored_polygon(arrow, used_color)
		lower_branch_node.draw_line(middle_position, end_position, used_color, line_width)
	else:
		var second_part:Vector2 = Vector2(middle_position.x, height-8)
		var first_part:Vector2 = Vector2(middle_position.x, height-16)
		lower_branch_node.draw_line(middle_position, first_part, used_color, line_width)
		lower_branch_node.draw_line(Vector2(lerp(0, width, 0.2), height-8), Vector2(lerp(0, width, 0.8), height-8), used_color, 4)
		lower_branch_node.draw_line(second_part, end_position, used_color, line_width)
		lower_branch_node.draw_line(Vector2(lerp(0, width, 0.2), height-16), Vector2(lerp(0, width, 0.8), height-16), used_color, 4)
