tool
extends "res://addons/dialog_plugin/Other/resource_array.gd"
class_name PortraitArray

func _init() -> void:
	self._hint_string = "DialogPortraitResource"
	var _default_portrait = DialogPortraitResource.new()
	_default_portrait.name = "Default"
	_default_portrait.image = load("res://icon.png")
	self._resources.append(_default_portrait)
