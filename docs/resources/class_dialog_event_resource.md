# DialogEventResource
#### **Inherits:** [Resource]()
#### **Inherited by:** [DialogTextEvent](), [DialogCharacterJoinEvent](), [DialogCharacterLeaveEvent](), [DialogWaitTimeEvent]()

Base class for all dialog `event`s.

## Description
Every dialog event relies on this class. If you want to do your own event, you should `extend` this class.
## Properties
Type|Name
---|---
DialogBaseNode|_caller
## Methods
Type|Name
---|---
void|excecute ( DialogBaseNode caller )
void|finish ( bool skip=false )
DialogEditorEventNode|get_editor_node ( )
## Signals
- event_started(event_resource)
- event_finished(event_resource)
## Enumerations
## Constants
## Property Descriptions
### ◽ 
## Method Descriptions
### ◽ 