tool

const DB_PATH = "res://addons/dialog_plugin/Database/"
const TIMELINEDB_PATH = DB_PATH+"SavedTimelines.tres"
const CHARACTERDB_PATH = DB_PATH+"SavedCharacters.tres"
const EDITOR_i18n_PATH = DB_PATH+"Editor_i18n.tres"
const TRANSLATIONSDB_PATH = DB_PATH+"SavedTranslations.tres"

const CONFIGURATION_PATH = DB_PATH+"EditorConfiguration.tres"
const DEFAULT_VARIABLES_PATH = DB_PATH+"SavedVariables.tres"
const DEFAULT_VARIABLES = preload(DEFAULT_VARIABLES_PATH)
#const USER_SAVED_VARIABLES_PATH = "user://SavedDialogData.res"

const RESOURCES_DIR = "res://dialog_files/"
const TIMELINES_DIR = RESOURCES_DIR+"timelines/"
const CHARACTERS_DIR = RESOURCES_DIR+"characters/"
const TRANSLATIONS_DIR = RESOURCES_DIR+"translations/"

const ICON_PATH_DARK = "res://addons/dialog_plugin/assets/Images/Plugin/plugin-editor-icon-dark-theme.svg"
const ICON_PATH_LIGHT = "res://addons/dialog_plugin/assets/Images/Plugin/plugin-editor-icon-light-theme.svg"

# This method should call a recursive one.
# But not for now
static func verify_resource_directories() -> void:
	_verify_resource_directory(RESOURCES_DIR)
	_verify_resource_directory(TIMELINES_DIR)
	_verify_resource_directory(CHARACTERS_DIR)
	_verify_resource_directory(TRANSLATIONS_DIR)
	
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
