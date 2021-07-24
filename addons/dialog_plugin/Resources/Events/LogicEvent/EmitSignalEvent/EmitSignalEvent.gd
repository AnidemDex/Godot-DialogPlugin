tool
extends "res://addons/dialog_plugin/Resources/EventResource.gd"

export(String) var custom_value:String = ""

func execute(caller:DialogBaseNode) -> void:
	caller.emit_signal("custom_signal", custom_value)
	finish(true)
