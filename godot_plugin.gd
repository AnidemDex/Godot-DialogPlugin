# MIT License

# Copyright (c) 2022 AnidemDex

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Take a look at the original repo to report issues or update script
# https://github.com/AnidemDex/Godot-PluginTemplate

tool
extends EditorPlugin

#####
# Plugin classes
#####

class WelcomeNode extends WindowDialog:
	
	##
	## The node popup that appears when you call show_welcome_node()
	##
	
	var _main_panel:TabContainer
	var _margin:MarginContainer
	var _menu:PopupMenu
	
	var _plugin_data:ConfigFile
	
	func _ready() -> void:
		add_stylebox_override("panel", get_stylebox("panel", "ProjectSettingsEditor"))
		
		_margin = MarginContainer.new()
		_margin.set_anchors_and_margins_preset(Control.PRESET_WIDE, Control.PRESET_MODE_KEEP_SIZE)
		_margin.add_constant_override("margin_top", 8)
		_margin.add_constant_override("margin_left", 2)
		_margin.add_constant_override("margin_right", 2)
		_margin.add_constant_override("margin_bottom", 16)
		add_child(_margin)
		
		_main_panel = TabContainer.new()
		_margin.add_child(_main_panel)
		
		_menu = PopupMenu.new()
		add_child(_menu)
		_main_panel.set_popup(_menu)
		
		add_tab("Information")
		add_tab("Plugin Info")
		
		var label = Label.new()
		label.text = "This plugin uses Plugin Template v%s"%__PLUGIN_VERSION
		add_child(label)
		label.set_anchors_and_margins_preset(Control.PRESET_BOTTOM_RIGHT)
		label.add_color_override("font_color", get_color("disabled_font_color", "Editor"))
		
		var plugin_information:VBoxContainer = get_tab_by_name("Plugin Info")
		
		if _plugin_data:
			var keys = _plugin_data.get_section_keys(__Constants.PLUGIN)
			for key in keys:
				var value = _plugin_data.get_value(__Constants.PLUGIN, key, "")
				var info_label := Label.new()
				info_label.text = "{key}: {value}".format({"key":key.capitalize(), "value":value})
				plugin_information.add_child(info_label)
	
	
	## Adds a tab to welcome popup
	func add_tab(tab_name:String) -> void:
		var tab = VBoxContainer.new()
		tab.name = tab_name
		_main_panel.add_child(tab)
	
	
	## Returns a Control node if find the node by its name
	func get_tab_by_name(tab_name) -> Control:
		var tab:Control = null
		for tab_idx in _main_panel.get_tab_count():
			var title = _main_panel.get_tab_title(tab_idx)
			if title == tab_name:
				tab = get_tab_by_idx(tab_idx)
				break
		return tab
	
	
	## Returns a Control node if find the node by its index
	func get_tab_by_idx(tab_idx:int) -> Control:
		var tab:Control = _main_panel.get_tab_control(tab_idx)
		return tab
	
	## Returns the TabContainer used by the node. DO NOT free it or you may cause
	## issues with nodes that deppends on this node.
	func get_tab_container() -> TabContainer:
		return _main_panel
	
	
	## Sets the data of the plugin using this node. Used internally
	func set_plugin_data(plugin_data:ConfigFile) -> void:
		_plugin_data = plugin_data


#####
# Plugin methods
#####

## Returns true if the plugin is editable. Useful for debug.
## To enable it, add "editable=true" in plugin.cfg file under "plugin" section.
func is_plugin_editable() -> bool:
	return __plugin_data.get_value(__Constants.PLUGIN, "editable", false)


## Returns the path of the script file
func get_plugin_path() -> String:
	var script:Script = get_script() as Script
	var path:String = ""
	# No idea why this should return null but anyway...
	if script:
		path = script.resource_path
	return path


## Returns the path of the folder that contains the plugin script.
func get_plugin_folder_path() -> String:
	var path:String = get_plugin_path()
	return path.get_base_dir()


## Returns the plugin's author.
func get_plugin_author() -> String:
	return __plugin_data.get_value(__Constants.PLUGIN, __Constants.AUTHOR, "")


## Returns the plugin's version
func get_plugin_version() -> String:
	return str(__plugin_data.get_value(__Constants.PLUGIN, __Constants.VERSION, ""))


## Returns the name of the plugin defined in plugin.cfg.
func get_plugin_real_name() -> String:
	return __plugin_data.get_value(__Constants.PLUGIN, __Constants.NAME, "")


## Returns the plugin's description.
func get_plugin_description() -> String:
	return __plugin_data.get_value(__Constants.PLUGIN, __Constants.DESCRIPTION, "")


## Returns the plugin's docs url. Defined in plugin.cfg as "docs" under plugin section.
func get_plugin_docs_url() -> String:
	return __plugin_data.get_value(__Constants.PLUGIN, __Constants.DOCS, "")


## Returns the plugin's repository url. Defined in plugin.cfg as "repository" under plugin section.
func get_plugin_repository() -> String:
	return __plugin_data.get_value(__Constants.PLUGIN, __Constants.REPOSITORY, "")


## Returns the plugin's license. This can be whatever the dev needs, from a URL to a simple string.
## Defined in plugin.cfg as "license" under plugin section.
func get_plugin_license() -> String:
	return __plugin_data.get_value(__Constants.PLUGIN, __Constants.LICENSE, "")


## Returns the plugin configuration file. This is the equivalent data file readed from plugin.cfg.
## All the plugin data will be saved to plugin.cfg.
func get_plugin_data() -> ConfigFile:
	return __plugin_data


## Returns the WelcomeNode popup used by the plugin.
## See WelcomeNode.
func get_plugin_welcome_node() -> WelcomeNode:
	return __welcome_node


## Registers a node as a node that belongs to this plugin.
## The node will be automatically freed when the plugin gets removed.
func register_plugin_node(node:Node) -> void:
	assert(node != null)
	
	assert(not node in __registered_nodes, "The node %s is already registered"%node)
	__registered_nodes.append(node)


## Alternative to add_control_to_dock().
## It registers a node as a node that belongs to this plugin and save its dock position
## even if the plugin is disabled.
## In order to save the node position in docks, you need to give it a name before register the node.
func register_control_to_dock(control:Control, dock_slot:int = -1) -> void:
	assert(control != null)
	
	# Restore previously saved slot if exists
	var plugin_data:ConfigFile = get_plugin_data()
	if control.name != "":
		control.name = control.name.capitalize().replace(" ", "")
	if dock_slot < 0:
		var dock_slot_name:String = plugin_data.get_value(__Constants.DOCK, control.name, "DOCK_SLOT_LEFT_UL")
		dock_slot = ClassDB.class_get_integer_constant("EditorPlugin", dock_slot_name)
	
	register_plugin_node(control)
	add_control_to_dock(dock_slot, control)
	
	assert(not control in __nodes_in_dock, "The node %s is already in dock"%control)
	__nodes_in_dock.append(control)


## Adds a node to the editor base control node.
## This is similar to do get_editor_interface().get_base_control().add_child(<Node>)
## but it registers the node as a node that belongs to this plugin.
func add_editor_node(node:Node) -> void:
	if not node in __registered_nodes:
		register_plugin_node(node)
	
	if not node.is_inside_tree():
		get_editor_interface().get_base_control().add_child(node)


## Shows the welcome node.
func show_welcome_node() -> void:
	var welcome_node:Control = get_plugin_welcome_node()
	# For some reason, hot reload makes all childs be out of the tree
	if not welcome_node.is_inside_tree():
		add_editor_node(welcome_node)
	get_plugin_welcome_node().popup_centered_ratio(0.45)


## Shows the plugin version button.
## VersionButton will appear next to Editor's version button.
func show_plugin_version_button() -> void:
	__version_button.show()


## Request, from another plugin, any method with variable number of arguments.
## `from_plugin` is plugin's name (defined with [get_plugin_name()] wich is the plugin real name
## by default.
## `method` is the method to call in the other plugin.
## `args` is an array that contains the arguments of the method call.
## This function only works with other plugins that uses PluginTemplate
func request(from_plugin:String, method:String, args:=[]):
	var plugin:EditorPlugin = get_plugin_or_null(from_plugin)
	if plugin == null:
		return
	
	assert(plugin.has_method(method))
	if plugin.has_method(method):
		return plugin.callv(method, args)


## Gets another plugin with `plugin_name`.
## `plugin_name` is plugin's name (defined with [get_plugin_name()] wich is the plugin real name
## by default.
## This function only works with other plugins that uses PluginTemplate. Returns null if was unable
## to find the plugin.
func get_plugin_or_null(plugin_name:String) -> EditorPlugin:
	if Engine.has_meta(plugin_name):
		return Engine.get_meta(plugin_name) as EditorPlugin
	return null

## Reloads plugin data from plugin.cfg
func reload_plugin_data() -> void:
	var _err = __plugin_data.load(get_plugin_folder_path()+"/plugin.cfg")
	assert(_err == OK, "There was an error while loading plugin data: %s"%_err)

####
# "Virtual" methods
####

func _get_plugin_name() -> String:
	return get_plugin_real_name()

func _get_state() -> Dictionary:
	var plugin_data:ConfigFile = get_plugin_data()
	var state = plugin_data.get_value("state", "plugin_state", {})
	return state

#####
# Virtual functions replaced with custom ones
# Why? Because the template needs those **and** virtual methods 
# are usually marked with a _ prefix in Godot.
# Ok but why all? Just in case I need to add different behaviours to those.
#####

func apply_changes() -> void:
	if has_method("_apply_changes"):
		call("_apply_changes")


func build() -> bool:
	if has_method("_build"):
		return call("_build")
	return true


func clear() -> void:
	if has_method("_clear"):
		call("_clear")


func disable_plugin() -> void:
	if has_method("_disable_plugin"):
		call("_disable_plugin")


func edit(object:Object) -> void:
	if has_method("_edit"):
		call("_edit", object)


func enable_plugin() -> void:
	if has_method("_enable_plugin"):
		call("_enable_plugin")


func forward_canvas_draw_over_viewport(overlay: Control) -> void:
	if has_method("_forward_canvas_draw_over_viewport"):
		call("_forward_canvas_draw_over_viewport", overlay)


func forward_canvas_force_draw_over_viewport(overlay: Control) -> void:
	if has_method("_forward_canvas_force_draw_over_viewport"):
		call("_forward_canvas_force_draw_over_viewport", overlay)


func forward_canvas_gui_input(event: InputEvent) -> bool:
	if has_method("_forward_canvas_gui_input"):
		return call("_forward_canvas_gui_input", event)
	return false


func forward_spatial_draw_over_viewport(overlay: Control) -> void:
	if has_method("_forward_spatial_draw_over_viewport"):
		call("_forward_spatial_draw_over_viewport", overlay)


func forward_spatial_force_draw_over_viewport(overlay: Control) -> void:
	if has_method("_forward_spatial_force_draw_over_viewport"):
		call("_forward_spatial_force_draw_over_viewport", overlay)


func forward_spatial_gui_input(camera: Camera, event: InputEvent) -> bool:
	if has_method("_forward_spatial_gui_input"):
		return call("_forward_spatial_gui_input", camera, event)
	return false


func get_breakpoints() -> PoolStringArray:
	if has_method("_get_breakpoints"):
		return call("_get_breakpoints")
	return PoolStringArray()


func get_plugin_icon() -> Texture:
	if has_method("_get_plugin_icon"):
		return call("_get_plugin_icon")
	return get_editor_interface().get_base_control().get_icon("Node","EditorIcons")


func get_plugin_name() -> String:
	return _get_plugin_name()


func get_state() -> Dictionary:
	return _get_state()


func get_window_layout(layout: ConfigFile) -> void:
	# This is called when you call queue_save_layout()
	# [docks]
	# dock_?_x <Node.name> where ? can be filesystem_* split or hsplit and x is an integer
	# [EditorNode]
	# open_scenes []
	# [ScriptEditor]
	# open_scripts [] Array of dicts
	# open_help [] PoolStringArray
	# split_offset <int>
	var plugin_data:ConfigFile = get_plugin_data()
	
	if plugin_data.has_section(__Constants.DOCK):
		plugin_data.erase_section(__Constants.DOCK)
	
	var dock_nodes_names = []
	for node in __nodes_in_dock:
		dock_nodes_names.append(node.name)
	
	for key in layout.get_section_keys(__Constants.DOCK):
		key = str(key)
		
		# Avoid other docks properties
		if key.length()>6:
			continue
		
		var dock_slot:int = int(key[5])-1
		var c_enum = ClassDB.class_get_enum_constants("EditorPlugin", "DockSlot")
		var names:String = layout.get_value(__Constants.DOCK, key, "")
		var node_names := names.split(",")
		for node_name in node_names:
			if node_name in dock_nodes_names:
				plugin_data.set_value(__Constants.DOCK, node_name, c_enum[dock_slot])
	
	if has_method("_get_window_layout"):
		call("_get_window_layout", layout)


func handles(object: Object) -> bool:
	if has_method("_handles"):
		return call("_handles", object)
	return false


func has_main_screen() -> bool:
	if has_method("_has_main_screen"):
		return call("_has_main_screen")
	return false


func make_visible(visible: bool) -> void:
	if has_method("_make_visible"):
		call("_make_visible", visible)


func save_external_data() -> void:
	var plugin_data:ConfigFile = get_plugin_data()
	
	if __plugin_sensible_data_modified:
		var message = "'{plugin}' sensible data was modified. The plugin will be reloaded."
		var plugin_good_name = get_plugin_folder_path().split("/")[-1]
		message = message.format({"plugin":get_plugin_name()})
		OS.call_deferred("alert", message)
		get_editor_interface().call_deferred("set_plugin_enabled", plugin_good_name, false)
		get_editor_interface().call_deferred("set_plugin_enabled", plugin_good_name, true)
	var _err = plugin_data.save(get_plugin_folder_path()+"/plugin.cfg")
	
	if has_method("_save_external_data"):
		call("_save_external_data")
	
	assert(_err == OK, "There was a problem while saving plugin data: %s"%_err)


func set_state(state: Dictionary) -> void:
	var plugin_data:ConfigFile = get_plugin_data()
	var key := __Constants.PLUGIN+"_"+__Constants.STATE
	plugin_data.set_value(__Constants.STATE, key, state)
	if has_method("_set_state"):
		call("_set_state", state)


func set_window_layout(layout: ConfigFile) -> void:
	# This is called when the plugin was enabled while the editor is restoring its layout
	# see get_window_layout
	if has_method("_set_window_layout"):
		call("_set_window_layout", layout)

#####
# Godot methods
#####

func _enter_tree() -> void:
	add_editor_node(__welcome_node)
	__add_plugin_version_button()


func _ready() -> void:
	__register_itself_on_editor()
	__register_plugin_template()


func _exit_tree() -> void:
	__cleanup()


func _set(property: String, value) -> bool:
	var plugin_data := get_plugin_data()
	var has_property := false
	
	for section in plugin_data.get_sections():
		if property.begins_with("plugin_"):
			property = property.replace("plugin_", "")
			__plugin_sensible_data_modified = true
		has_property = plugin_data.has_section_key(section, property)
		if has_property:
			plugin_data.set_value(section, property, value)
		if __plugin_sensible_data_modified:
			property_list_changed_notify()
			has_property = false # let default values go up
			
	return has_property


func _get(property: String):
	var plugin_data := get_plugin_data()
	for section in plugin_data.get_sections():
		if property.begins_with("plugin_"):
			property = property.replace("plugin_", "")
		if plugin_data.has_section_key(section, property):
			return plugin_data.get_value(section, property, null)


func _get_property_list() -> Array:
	var p := []
	
	for section in __plugin_data.get_sections():
		var pre := ""
		var _section:String = str(section)
		
		if _section == __Constants.PLUGIN:
			pre = _section+"_"
		
		p.append({"name":_section.capitalize(), "type":TYPE_NIL, "usage":PROPERTY_USAGE_CATEGORY})
		
		for key in __plugin_data.get_section_keys(section):
			var _key:String = str(key)
			var _value = __plugin_data.get_value(_section, _key)
			var _type:int = typeof(_value)
			var usage_hint := PROPERTY_USAGE_EDITOR
			
			if _section == __Constants.PLUGIN:
				usage_hint |= PROPERTY_USAGE_RESTART_IF_CHANGED
				if not is_plugin_editable():
					usage_hint = 0
			
			p.append({"name":pre+key, "type":_type, "usage":usage_hint})
	return p


func _init() -> void:
	__registered_nodes = []
	__nodes_in_dock = []
	
	__plugin_data = ConfigFile.new()
	reload_plugin_data()
	
	name = get_plugin_name()
	
	__welcome_node = WelcomeNode.new()
	__welcome_node.set_plugin_data(__plugin_data)
	__welcome_node.window_title = get_plugin_name().capitalize()
	register_plugin_node(__welcome_node)
	
	__version_button = ToolButton.new()
	register_plugin_node(__version_button)


#####
# Private
#####

# what is an struct?
class __Constants:
	const PLUGIN = "plugin"
	const VERSION = "version"
	const NAME = "name"
	const AUTHOR = "author"
	const SCRIPT = "script"
	const DESCRIPTION = "description"
	const DOCS = "docs"
	const REPOSITORY = "repository"
	const LICENSE = "license"
	const PLUGIN_TEMPLATE = "PluginTemplateHandler"
	const STATE = "state"
	const DOCK = "docks"


class __Logger:
	# Future idea: make a logger using CassianoBelniak/katuiche-colorful-console
	# it has to be an static class available in the whole editor
	enum LogType {DEBUG, INFO, WARNING, ERROR}


class __PluginTemplate extends EditorPlugin:
	class __NodeHandler extends EditorInspectorPlugin:
		
		var ignore_category = false
		
		func can_handle(object: Object) -> bool:
			return object is EditorPlugin
		
		
		func parse_begin(_object: Object) -> void:
			pass
		
		
		func parse_category(_object: Object, category: String) -> void:
			ignore_category = "Node" == category
		
		
		func parse_property(_object: Object, _type: int, _path: String, _hint: int, _hint_text: String, _usage: int) -> bool:
			if ignore_category:
				return true
			return false
	
	
	var node_handler := __NodeHandler.new()
	
	func _enter_tree() -> void:
		add_inspector_plugin(node_handler)
	
	
	func _ready() -> void:
		__register_itself_on_editor()
	
	
	func _exit_tree() -> void:
		remove_inspector_plugin(node_handler)
	
	# Copied from godot_plugin since we can't extend itself
	func __register_itself_on_editor() -> void:
		Engine.set_meta(__Constants.PLUGIN_TEMPLATE, self)


const __PLUGIN_VERSION = 0.1

var __plugin_data:ConfigFile
var __welcome_node:WelcomeNode
var __version_button:BaseButton

var __registered_nodes:Array = []
var __nodes_in_dock:Array = []

var __plugin_sensible_data_modified:bool = false

func __add_plugin_version_button() -> void:
	if __version_button.is_inside_tree():
		return
	
	var _v = {"version":get_plugin_version(), "plugin_name":get_plugin_name()}
	
	__version_button.set("text", "[{version}]".format(_v))
	__version_button.hint_tooltip = "{plugin_name} version {version}".format(_v)
	var _e = __version_button.connect("pressed", self, "__WelcomeButton_pressed")
	
	var _new_color = __version_button.get_color("font_color")
	_new_color.a = 0.6
	__version_button.add_color_override("font_color", _new_color)
	__version_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	var _dummy := Control.new()
	var _dock_button := add_control_to_bottom_panel(_dummy, "dummy")
	_dock_button.get_parent().get_parent().add_child(__version_button)
	_dock_button.get_parent().get_parent().move_child(__version_button, 1)
	remove_control_from_bottom_panel(_dummy)
	_dummy.free()
	
	__version_button.hide()


func __request_configuration() -> void:
	if not is_instance_valid(get_editor_interface().get_edited_scene_root()):
		return
	get_editor_interface().inspect_object(self)


func __register_itself_on_editor() -> void:
	# Technically we can use get_tree(), but I don't rely on tree order
	Engine.set_meta(get_plugin_name(), self)
	add_tool_menu_item(get_plugin_name(), self, "__ToolMenu_item_pressed")
	var _e = connect("tree_exiting", self, "remove_tool_menu_item", [get_plugin_name()])


func __register_plugin_template() -> void:
	var plugin:EditorPlugin = get_plugin_or_null(__Constants.PLUGIN_TEMPLATE) as EditorPlugin
	if plugin != null:
		return
	plugin = __PluginTemplate.new()
	plugin.name = __Constants.PLUGIN_TEMPLATE
	get_parent().add_child(plugin)


func __WelcomeButton_pressed() -> void:
	__request_configuration()
	show_welcome_node()


func __ToolMenu_item_pressed(_d):
	__request_configuration()
	show_welcome_node()


func __cleanup() -> void:
	queue_save_layout()
	for node in __registered_nodes:
		if not is_instance_valid(node):
			# For some reason is null???
			continue
		
		if node in __nodes_in_dock:
			remove_control_from_docks(node)
		
		node.free()
	
	__registered_nodes.clear()
	__nodes_in_dock.clear()
	
	save_external_data()
