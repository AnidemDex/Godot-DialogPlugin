tool
extends VBoxContainer

export(NodePath) var Icon_path:NodePath
export(NodePath) var LowBranch_path:NodePath

var base_resource:DialogEventResource = null

onready var lower_branch_node:Control = get_node(LowBranch_path) as Control
onready var icon_node:TextureRect = get_node(Icon_path) as TextureRect


func update_node_values() -> void:
	print_debug("Updating branch")
	lower_branch_node.update()
	icon_node.texture = base_resource.event_icon if base_resource else null


func _on_LowerBranch_draw() -> void:
	if not base_resource:
		return
	
	var line_width:float = 4.0
	var height:float = lower_branch_node.rect_size.y
	var width:float = lower_branch_node.rect_size.x
	var middle_position:Vector2 = Vector2(width/2,0)
	var end_position:Vector2 = Vector2(0, height/2) + middle_position
	lower_branch_node.draw_line(middle_position, end_position, Color.black, line_width)
	var _skip:bool = base_resource.skip
	
	if _skip:
		var arrow:PoolVector2Array = PoolVector2Array([Vector2(width/2, height), Vector2(lerp(0, width, 0.2), height/2), Vector2(lerp(0, width, 0.8), height/2)])
		lower_branch_node.draw_colored_polygon(arrow, Color.black)
