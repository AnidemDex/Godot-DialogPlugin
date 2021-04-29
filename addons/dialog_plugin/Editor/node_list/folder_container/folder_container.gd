tool
extends PanelContainer

export(NodePath) var FolderName_path:NodePath
export(NodePath) var NodeContainer_path:NodePath

onready var folder_name:Label = get_node_or_null(FolderName_path)
onready var node_container = get_node_or_null(NodeContainer_path)

func _ready() -> void:
	$VBoxContainer2/HBoxContainer/TextureRect.texture = get_icon("FolderBigThumb", "EditorIcons")
