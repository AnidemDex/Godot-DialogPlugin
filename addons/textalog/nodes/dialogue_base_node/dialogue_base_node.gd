extends Control
class_name DialogNode

signal text_displayed

signal portrait_added(character, portrait)
signal portrait_changed(character, portrait)
signal portrait_removed(character)

signal option_added(option_button)
signal option_selected(option_string)

export(NodePath) var DialogNode_Path:NodePath
export(NodePath) var PortraitNode_Path:NodePath
export(NodePath) var OptionsNode_Path:NodePath

var dialog_manager:DialogManager
var portrait_manager:PortraitManager
var options_manager:OptionsManager

func show_text(text:String, with_text_speed:float=0):
	if not is_instance_valid(dialog_manager):
		return
	
	dialog_manager.set_text(text)
	dialog_manager.display_text()


func add_option(option:String) -> void:
	if not is_instance_valid(options_manager):
		return
	
	options_manager.add_option(option)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_POST_ENTER_TREE:
			_fake_ready()


func _fake_ready() -> void:
	_set_default_nodes()
	_connect_dialog_manager_signals()
	_connect_portrait_manager_signals()

func _set_default_nodes():
	# This has to be done manually since POST_ENTER_TREE is too early
	# and NOTIFICATION_READY is too late to get an onready variable
	
	dialog_manager =  get_node_or_null(DialogNode_Path) as DialogManager
	portrait_manager = get_node_or_null(PortraitNode_Path) as PortraitManager
	options_manager = get_node_or_null(OptionsNode_Path) as OptionsManager


func _connect_dialog_manager_signals():
	if not is_instance_valid(dialog_manager):
		return
	
	if not dialog_manager.is_connected("text_displayed", self, "emit_signal"):
		dialog_manager.connect("text_displayed", self, "emit_signal", ["text_displayed"])

func _connect_portrait_manager_signals():
	if not is_instance_valid(portrait_manager):
		return
	
	
	if not portrait_manager.is_connected("portrait_added", self, "__on_PortraitManager_portrait_added"):
		portrait_manager.connect("portrait_added", self, "__on_PortraitManager_portrait_added")
	if not portrait_manager.is_connected("portrait_changed", self, "__on_PortraitManager_portrait_changed"):
		portrait_manager.connect("portrait_changed", self, "__on_PortraitManager_portrait_changed")
	if not portrait_manager.is_connected("portrait_removed", self, "__on_PortraitManager_portrait_removed"):
		portrait_manager.connect("portrait_removed", self, "__on_PortraitManager_portrait_removed")


func __on_PortraitManager_portrait_added(character, portrait) -> void:
	print(character)
	emit_signal("portrait_added", character, portrait)

func __on_PortraitManager_portrait_changed(character, portrait) -> void:
	emit_signal("portrait_changed", character, portrait)

func __on_PortraitManager_portrait_removed(character) -> void:
	emit_signal("portrait_removed", character)

func __on_OptionManager_option_added(option_button) -> void:
	emit_signal("option_added", option_button)

func __on_OptionManager_option_selected(option_string) -> void:
	emit_signal("option_selected", option_string)
