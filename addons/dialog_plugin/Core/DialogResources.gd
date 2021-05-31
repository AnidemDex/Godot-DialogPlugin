tool

# DEPRECATED
# I'll probably remove these ASAP
const DB_PATH = "res://addons/dialog_plugin/Database/"
const TIMELINEDB_PATH = DB_PATH+"SavedTimelines.tres"
const CHARACTERDB_PATH = DB_PATH+"SavedCharacters.tres"
const EDITOR_i18n_PATH = DB_PATH+"Editor_i18n.tres"
const TRANSLATIONSDB_PATH = DB_PATH+"SavedTranslations.tres"

const CONFIGURATION_PATH = DB_PATH+"EditorConfiguration.tres"
const DEFAULT_VARIABLES_PATH = DB_PATH+"SavedVariables.tres"
#const DEFAULT_VARIABLES = preload(DEFAULT_VARIABLES_PATH)
#const USER_SAVED_VARIABLES_PATH = "user://SavedDialogData.res"

const RESOURCES_DIR = "res://dialog_files/"
const TIMELINES_DIR = RESOURCES_DIR+"timelines/"
const CHARACTERS_DIR = RESOURCES_DIR+"characters/"
const TRANSLATIONS_DIR = RESOURCES_DIR+"translations/"

const ICON_PATH_DARK = "res://addons/dialog_plugin/assets/Images/Plugin/plugin-editor-icon-dark-theme.svg"
const ICON_PATH_LIGHT = "res://addons/dialog_plugin/assets/Images/Plugin/plugin-editor-icon-light-theme.svg"

const TIMELINE_EDITOR_PATH = "res://addons/dialog_plugin/Editor/Views/timeline_editor/TimelineEditorView.tscn"
const CHARACTER_EDITOR_PATH = "res://addons/dialog_plugin/Editor/Views/character_editor/CharacterEditorView.tscn"
const VARIABLE_EDITOR_PATH = "res://addons/dialog_plugin/Editor/Views/variable_editor/DefinitionEditorView.tscn"


const TIMELINE_PLUGIN_MANAGER = "dialog_plugin/plugin_editor_manager/timeline_editor"
const CHARACTER_PLUGIN_MANAGER = "dialog_plugin/plugin_editor_manager/character_editor"
const VARIABLE_PLUGIN_MANAGER = "dialog_plugin/plugin_editor_manager/variable_editor"


# DEPRECATED
# This method should call a recursive one.
# But not for now
static func verify_resource_directories() -> void:
	var _directories = [
		RESOURCES_DIR, 
		TIMELINES_DIR, 
		CHARACTERS_DIR, 
		TRANSLATIONS_DIR,
	]
	for _dir in _directories:
		_verify_resource_directory(_dir)
	
	print("{i} {m}".format({"i":"[DialogResources]","m":"All folders verified"}))


static func _verify_resource_directory(directory_path:String) -> void:
	var _info = "[DialogResources]"
	var _d = Directory.new()
	if not _d.dir_exists(directory_path):
		var _dir_name = directory_path.get_base_dir().split("/")[-1]
		var _message = "{dir_name} folder doesn't exist".format({"dir_name":_dir_name})
		
		print("{i} {m}".format({"i":_info,"m":_message}))
		var _err = _d.make_dir_recursive(directory_path)
		if _err != OK:
			print("{i} {m} -> ".format({"i":_info,"m":"Failed, skipping"}), _err)
			return
		_message = "{dir_name} folder created.".format({"dir_name":_dir_name})
		print("{i} {m}".format({"i":_info,"m":_message}))
	pass
