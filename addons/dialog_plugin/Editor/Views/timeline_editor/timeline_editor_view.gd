tool
extends Control

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")
const TranslationDB = preload("res://addons/dialog_plugin/Core/DialogDatabase.gd").Translations
const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")

const EventsDisplayer = preload("res://addons/dialog_plugin/Editor/Views/timeline_editor/events_displayer.gd")

export(NodePath) var TimelineEventsContainer_path:NodePath
export(NodePath) var LocaleList_path:NodePath
export(NodePath) var LISelected_path:NodePath

export(String, FILE) var debug_base_resource:String = ""

var base_resource:DialogTimelineResource setget _set_base_resource

onready var timeline_events_container_node:EventsDisplayer = get_node_or_null(TimelineEventsContainer_path) as EventsDisplayer
onready var locale_list_node:OptionButton = get_node(LocaleList_path) as OptionButton
onready var last_item_selected_node:Label = get_node(LISelected_path) as Label

func _ready() -> void:
	if (not Engine.editor_hint) and (debug_base_resource != ""):
			base_resource = load(debug_base_resource) as DialogTimelineResource
	if base_resource == null:
		return
	
	timeline_events_container_node.timeline_resource = base_resource

func _process(delta: float) -> void:
	if not timeline_events_container_node:
		return
	if "last_selected_node" in timeline_events_container_node:
		var last_item_selected = timeline_events_container_node.last_selected_node
		if last_item_selected and is_instance_valid(last_item_selected):
			last_item_selected_node.text = str(last_item_selected.idx)
		else:
			last_item_selected_node.text = str(null)

func reload():
	timeline_events_container_node.unload_events()
	timeline_events_container_node.load_events()


func _clips_input() -> bool:
	return true


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			if visible and (base_resource != null):
				reload()


func save_resource() -> void:
	if not base_resource:
		printerr("There's no resource to save, skiping")
		return
	var _err = ResourceSaver.save(base_resource.resource_path, base_resource)
	assert(_err == OK, "There was an error while saving a resource in {path}: {error}".format({"path":base_resource.resource_path, "error":_err}))


func _set_base_resource(_r:DialogTimelineResource) -> void:
	if not _r:
#		push_error("No resource")
		return

	base_resource = _r
	timeline_events_container_node.timeline_resource = base_resource
	DialogUtil.Logger.print(self,["Using {res} at {path}".format({"res":base_resource.get_class(), "path":_r.resource_path})])


func _on_LocaleList_item_selected(index: int) -> void:
	var _locale = locale_list_node.get_item_metadata(index)
	if _locale == TranslationService.get_project_locale(true):
		_locale = ""
	ProjectSettings.set_setting("locale/test", _locale)


func _on_EventButtonsContainer_event_pressed(event_resource:DialogEventResource) -> void:
	var _last_selected_node = timeline_events_container_node.last_selected_node
	if _last_selected_node and is_instance_valid(_last_selected_node):
		timeline_events_container_node.add_event(event_resource, _last_selected_node.idx+1)
	else:
		timeline_events_container_node.add_event(event_resource)
