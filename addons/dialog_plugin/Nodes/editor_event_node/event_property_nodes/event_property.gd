# Collection of Control nodes to be used in TimelineEditor
# why? Because I can't extend two same types at once

class PControl extends Control:
	export(String) var used_property:String
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
		
		if not base_resource.is_connected("changed", self, "update_node_values"):
			base_resource.connect("changed", self, "update_node_values")
		
		update_node_values()


class PTextEdit extends TextEdit:
	export(String) var used_property:String
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
		
		if not base_resource.is_connected("changed", self, "update_node_values"):
			base_resource.connect("changed", self, "update_node_values")
		
		update_node_values()


class POptionButton extends OptionButton:
	export(String) var used_property:String
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
		
		if not base_resource.is_connected("changed", self, "update_node_values"):
			base_resource.connect("changed", self, "update_node_values")
		
		update_node_values()


class PCheckButton extends CheckButton:
	export(String) var used_property:String
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
		
		if not base_resource.is_connected("changed", self, "update_node_values"):
			base_resource.connect("changed", self, "update_node_values")
		
		update_node_values()

class PLabel extends Label:
	export(String) var used_property:String
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
		
		if not base_resource.is_connected("changed", self, "update_node_values"):
			base_resource.connect("changed", self, "update_node_values")
		
		update_node_values()


class PSlider extends Slider:
	export(String) var used_property:String
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
		
		if not base_resource.is_connected("changed", self, "update_node_values"):
			base_resource.connect("changed", self, "update_node_values")
		
		update_node_values()


class PResourceSelector extends "res://addons/dialog_plugin/Nodes/misc/resource_selector/resource_selector.gd":
	export(String) var used_property:String
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
		
		if not base_resource.is_connected("changed", self, "update_node_values"):
			base_resource.connect("changed", self, "update_node_values")
		
		update_node_values()

class PCharacterSelector extends "res://addons/dialog_plugin/Nodes/misc/character_selector/character_selector.gd":
	export(String) var used_property:String
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
		
		if not base_resource.is_connected("changed", self, "update_node_values"):
			base_resource.connect("changed", self, "update_node_values")
		
		update_node_values()
