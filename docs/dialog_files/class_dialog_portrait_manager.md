# DialogPortraitManager
#### **Inherits:** [Control][class_control]

Base class for any `DialogPortraitManager` node.

## Description
Takes care of the displayed portrait of any character, saving their reference.


## Properties
Type|Name
---|---
NodePath|LeftNode_path
NodePath|CenterLeftNode_path
NodePath|CenterNode_path
NodePath|CenterRightNode_path
NodePath|RightNode_path
NodePath|portraits

## Methods
Type|Name
---|---
void |add_portrait ( DialogCharacterResource character_resource, DialogPortraitResource portrait, Position position=Position.CENTER, PAnimation animation=PAnimation.NO_ANIMATION, bool get_focus=true )
void |remove_portrait ( Node portrait_node )
void |grab_portrait_focus ( TextureRect char_portrait_node, PAnimation animation)

## Signals
- **portrait_added(** character **)**
  Emmited when a `character`(`DialogCharacterResource`) portrait was added.

## Enumerations
- **PAnimation**
  - NO_ANIMATION
  - FADE_IN
  - APPEAR
  - DISAPPEAR 
  - FADE_OUT

- **Position**
  - CENTER
  - CENTER_LEFT
  - CENTER_RIGHT
  - LEFT
  - RIGHT

## Constants
## Property Descriptions
### ◽ Dictionary portraits
{CharacterResource: PortraitNode->TextureRect}
## Method Descriptions
### ◽ 

[class_control]:#