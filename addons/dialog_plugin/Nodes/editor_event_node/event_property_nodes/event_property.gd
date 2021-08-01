# Collection of Control nodes to be used in TimelineEditor

class PControl extends Control:
	var used_property:String
	var base_resource:DialogEventResource
	
	func update_node_values() -> void:
		return
	
	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_READY:
				call_deferred("_pseudo_ready")
	
	func _pseudo_ready():
		if not base_resource:
			return
				
		base_resource.connect("changed", self, "update_node_values")
		update_node_values()


class PTextEdit extends TextEdit:
	var used_property:String
	var base_resource:DialogEventResource
	
	func update_node_values() -> void:
		return
	
	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_READY:
				call_deferred("_pseudo_ready")
	
	func _pseudo_ready():
		if not base_resource:
			return
				
		base_resource.connect("changed", self, "update_node_values")
		update_node_values()


class PResourceSelector extends "res://addons/dialog_plugin/Nodes/misc/resource_selector/resource_selector.gd":
	var used_property:String
	var base_resource:DialogEventResource
	
	func update_node_values() -> void:
		return
	
	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_READY:
				call_deferred("_pseudo_ready")
	
	func _pseudo_ready():
		if not base_resource:
			return
				
		base_resource.connect("changed", self, "update_node_values")
		update_node_values()
