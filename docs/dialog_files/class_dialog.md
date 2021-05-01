# Dialog

Static class to deal with Dialog plugin.

## Description

You can call any of these methods from any script.

## Methods
Type|Name
-----|-----
void|[start](#-void-start-timeline-string-dialog_scene_path-bool-use_bubblefalse-) (timeline, String dialog_scene_path="", bool use_bubble=false)
DialogBaseNode|[get_default_dialog_textbox](#-dialogbasenode-get_default_dialog_textbox--) ()
DialogBaseNode|[get_default_dialog_bubble](#-dialogbasenode-get_default_dialog_bubble--) ()

## Constants
- DefaultDialogTextBox:String --- Default dialog text box scene path
- DefaultDialogBubble:String --- Default dialog bubble scene path

## Method Descriptions

### ◽ void **start(** timeline, String dialog_scene_path="", bool use_bubble=false **)**

### ◽ [DialogBaseNode][class_dialog_base_node] **get_default_dialog_textbox ( )**
Returns a DialogBaseNode instance of the default textbox.

### ◽ [DialogBaseNode][class_dialog_base_node] **get_default_dialog_bubble ( )**
Returns a [DialogBaseNode][class_dialog_base_node] instance of the default dialog bubble.

[class_dialog_base_node]:.