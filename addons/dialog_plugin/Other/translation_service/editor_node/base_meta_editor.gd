tool
extends Control

## Shows metadata
## Let the meta be edited
## Ideal to have a hint for the translator

## Extend if you want to had your own metadata

var BaseNode:Control

func _ready() -> void:
	if not BaseNode:
		push_error("There is no node to modify")
		visible = false
	else:
		visible = true
		var meta = BaseNode.get_meta_list()
		if "HINT_TOOLTIP_KEY" in meta:
			$Category/Editors/HintTooltip_LineEdit.text = BaseNode.get_meta("HINT_TOOLTIP_KEY")


func _on_HintTooltip_LineEdit_text_changed(new_text: String) -> void:
	if not new_text:
		BaseNode.set_meta("HINT_TOOLTIP_KEY", null)
	else:
		BaseNode.set_meta("HINT_TOOLTIP_KEY", new_text)
