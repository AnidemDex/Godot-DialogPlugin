tool
extends AcceptDialog

const ENABLED_MSG = "EventSystem is {n} enabled"

export(NodePath) var EveSysStatus:NodePath
export(NodePath) var Retry_button:NodePath

var _docs:String = ""
var _repo:String = ""
var _license:String = ""
var _credits:String = ""

var _textalog_plugin = null

onready var evesys_status:Label = get_node(EveSysStatus) as Label
onready var retry_btn:Button = get_node(Retry_button) as Button

func _on_Documentation_pressed() -> void:
	OS.shell_open(_docs)


func _on_Repository_pressed() -> void:
	OS.shell_open(_repo)


func _on_License_pressed() -> void:
	OS.shell_open(_license)


func _on_Credits_pressed() -> void:
	OS.shell_open(_credits)


func _update_evesys_status() -> void:
	if not _textalog_plugin:
		return
	
	var _evesys_enabled:bool = _textalog_plugin.is_event_system_enabled()
	var negation = {"n":"not"}
	var status_color = get_color("error_color", "Editor")
	var style = get_stylebox("Background", "EditorStyles")
	var enable_retry:bool = true
	if _evesys_enabled:
		status_color = get_color("success_color", "Editor")
		negation["n"] = ""
		enable_retry = false
	
	evesys_status.text = ENABLED_MSG.format(negation)
	evesys_status.add_color_override("font_color", status_color)
	evesys_status.add_stylebox_override("normal", style)
	
	retry_btn.visible = enable_retry

func _notification(what: int) -> void:
	if what == NOTIFICATION_POST_POPUP:
		_update_evesys_status()


func _on_Retry_pressed() -> void:
	_textalog_plugin.enable_event_system()
	_textalog_plugin.call_deferred("call_deferred", "_show_welcome")
	hide()
