tool
extends AcceptDialog

const DOCUMENTATION_PAGE = "https://godotplugins.gitbook.io/textalog/"
const REPOSITORY_PAGE = "https://github.com/AnidemDex/Godot-DialogPlugin"
const LICENSE = "https://github.com/AnidemDex/Godot-DialogPlugin/blob/main/LICENSE"
const CREDITS = "https://twitter.com/AnidemDex"

func _on_Documentation_pressed() -> void:
	OS.shell_open(DOCUMENTATION_PAGE)


func _on_Repository_pressed() -> void:
	OS.shell_open(REPOSITORY_PAGE)


func _on_License_pressed() -> void:
	OS.shell_open(LICENSE)


func _on_Credits_pressed() -> void:
	OS.shell_open(CREDITS)
