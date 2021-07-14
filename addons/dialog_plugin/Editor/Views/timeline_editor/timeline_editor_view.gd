tool
extends Control

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")
const TranslationDB = preload("res://addons/dialog_plugin/Core/DialogDatabase.gd").Translations
const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")

const EventsDisplayer = preload("res://addons/dialog_plugin/Editor/Views/timeline_editor/events_displayer.gd")

export(NodePath) var TimelineEventsContainer_path:NodePath
export(NodePath) var LocaleList_path:NodePath
export(NodePath) var Status_path:NodePath
export(NodePath) var ResName_path:NodePath
export(NodePath) var LoadProgress_path:NodePath

export(String, FILE) var debug_base_resource:String = ""

var base_resource:DialogTimelineResource setget _set_base_resource

onready var timeline_events_container_node:EventsDisplayer = get_node_or_null(TimelineEventsContainer_path) as EventsDisplayer
onready var locale_list_node:OptionButton = get_node(LocaleList_path) as OptionButton
onready var status_node:Label = get_node(Status_path) as Label
onready var timeline_name_node:Label = get_node(ResName_path) as Label
onready var loading_progress_node:ProgressBar = get_node(LoadProgress_path) as ProgressBar

func get_class(): return "TimelineEditorView"

func _ready() -> void:
	if (not Engine.editor_hint) and (debug_base_resource != ""):
			base_resource = load(debug_base_resource) as DialogTimelineResource
	if base_resource == null:
		return
	
	timeline_events_container_node.timeline_resource = base_resource


func reload():
	DialogUtil.Logger.print_debug(self, "Reloading events...")
	timeline_events_container_node.unload_events()
	timeline_events_container_node.load_events()
	update_status_label()
	update_resource_name_label()


func update_status_label() -> void:
	var is_modified:bool = timeline_events_container_node.modified
	status_node.text = "Modified" if is_modified else "Saved"


func update_resource_name_label() -> void:
	var res_name:String = base_resource.resource_path
	res_name = res_name.get_file()
	timeline_name_node.text = res_name


func _clips_input() -> bool:
	return true


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			if visible and (base_resource != null):
				reload()


func save_resource() -> void:
	if timeline_events_container_node.modified:
		call_deferred("_deferred_save")


func _deferred_save(_descarted_value=null) -> void:
	DialogUtil.Logger.print_debug(self, "Saving a resource.")
	if not base_resource:
		DialogUtil.Logger.print_debug(self, "There's no resource to save. Skipping")
		return
	var _err = ResourceSaver.save(base_resource.resource_path, base_resource)
	DialogUtil.Logger.verify(_err == OK, "There was an error while saving a resource in {path}: {error}".format({"path":base_resource.resource_path, "error":_err}))
	timeline_events_container_node.set_deferred("modified", false)


func _exit_tree() -> void:
	DialogUtil.Logger.print_debug(self, "Exiting the tree")
	save_resource()
	DialogUtil.Logger.print_debug(self, "Resource Saved.")


func _set_base_resource(_resource:DialogTimelineResource) -> void:
	base_resource = _resource
	timeline_events_container_node.timeline_resource = base_resource
	if base_resource:
		DialogUtil.Logger.print_info(self,["Using {res} at {path}".format({"res":base_resource.get_class(), "path":_resource.resource_path})])


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


func _on_TimelineEventsContainer_modified() -> void:
	update_status_label()


func _on_TimelineEventsContainer_displayer_loaded() -> void:
	$Lock.hide()
	loading_progress_node.hide()


func _on_TimelineEventsContainer_displayer_loading() -> void:
	$Lock.show()
	loading_progress_node.value = timeline_events_container_node.load_progress * 100
	loading_progress_node.show()
