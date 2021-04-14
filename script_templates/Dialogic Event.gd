tool
# class_name <your_event_class_name_here>
extends DialogEventResource

func excecute(caller:DialogNode)%VOID_RETURN%:
    # Parent function must be called at the start
    .excecute(caller)

    # There goes your event code.

    # Notify that you end this event
    finish()


# Returns DialogEditorEventNode to be used inside the editor.
#func get_event_editor_node() -> DialogEditorEventNode:
#return DialogEditorEventNode.new()