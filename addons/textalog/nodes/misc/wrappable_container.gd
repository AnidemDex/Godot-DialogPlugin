tool
extends Container
#class_name WrappContainer

## Modified version of 
## https://twitter.com/JaanusJaggo/status/1462902907993481217?s=20
## by AnidemDex to be used in 
## [Textalog](https://github.com/AnidemDex/Godot-DialogPlugin)

## Use it as you want

export(int) var hseparation = 1 setget set_h_separation
export(int) var vseparation = 1 setget set_v_separation

func set_h_separation(value:int) -> void:
	hseparation = value
	add_constant_override("hseparation", value)
	property_list_changed_notify()
	queue_sort()


func set_v_separation(value:int) -> void:
	vseparation = value
	add_constant_override("vseparation", value)
	property_list_changed_notify()
	queue_sort()


func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		_calculate_layout(true)


func _get_minimum_size() -> Vector2:
	return _calculate_layout()


func _calculate_layout(apply : bool=false) -> Vector2:
	var x = 0
	var ms = Vector2()
	var y = 0
	var hseparation:int = get_constant("hseparation")
	var vseparation:int = get_constant("vseparation")
	
	for child in get_children():
		child = child as Control
		
		if !child or not child.is_visible_in_tree():
			continue
		
		if child.is_set_as_toplevel():
			continue
		
		
		var minsize:Vector2 = child.get_combined_minimum_size()
		
		if rect_size.x < x + minsize.x:
			if x > 0:
				y += ms.y + vseparation
			else:
				y += ms.y
			x = 0
		
		if apply:
			fit_child_in_rect(child, Rect2(Vector2(x,y), minsize))
			minimum_size_changed()
			
		x += minsize.x + hseparation
		
		ms.y = max(minsize.y, ms.y)
		ms.x = max(minsize.x, ms.x)
	
	return Vector2(ms.x, y + ms.y)
