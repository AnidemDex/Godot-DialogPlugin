# DialogEditorEventNode
#### **Inherits:** [Control][class_control]
#### **Inherited by:** [<who>]()

Base class for all event editor nodes.

## Description
This is the generic node that is displayed inside the timeline editor. You can extend this class on any control node.

## Properties
Type|Name
---|---
DialogEventResource|base_resource
int|idx
NodePath|IconNode_path
NodePath|TopContent_path
NodePath|CenterContent_path
NodePath|BottomContent_path
NodePath|IndexLbl_path
NodePath|MenuBtn_path
PanelContainer|top_content_node
PanelContainer|center_content_node
PanelContainer|bottom_content_node
TextureRect|icon_node
Label|index_label_node
MenuButton|menu_button_node

## Methods
Type|Name
---|---
## Signals
- delelete_item_requested(item)
- save_item_requested(item)
- item_selected(item)
## Enumerations

## Constants
- DialogUtil

## Property Descriptions
### ◽ 

## Method Descriptions
### ◽ 

[class_control]:#