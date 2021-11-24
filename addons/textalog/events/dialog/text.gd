extends Event

const SAME_AS_TEXT = "__SAME_AS_TEXT__"

export(String) var display_name:String = "" setget set_display_name
export(String) var translation_key:String = SAME_AS_TEXT setget set_translation_key
export(String, MULTILINE) var text:String = "" setget set_text
export(float, 0.01, 1.0, 0.01) var text_speed:float = 0.04 setget set_text_speed
export(bool) var continue_previous_text:bool = false setget enable_text_ammend

var character:Character = null setget set_character

var blip_sounds:Array = []
var blip_loop:bool = false
var blip_force:bool = false
var blip_audio_bus:String = "Master"

var sound_generator:AudioStreamPlayer = null

var _dialog_manager:DialogManager = null
var _generator := RandomNumberGenerator.new()
var _already_played:bool = false

func set_display_name(value:String) -> void:
    display_name = value
    emit_changed()
    property_list_changed_notify()


func set_text(value:String) -> void:
    text = value
    emit_changed()
    property_list_changed_notify()


func set_text_speed(value:float) -> void:
    text_speed = value
    emit_changed()
    property_list_changed_notify()


func enable_text_ammend(value:bool) -> void:
    continue_previous_text = value
    emit_changed()
    property_list_changed_notify()


func set_translation_key(value:String) -> void:
    translation_key = value if value != "" else SAME_AS_TEXT
    emit_changed()
    property_list_changed_notify()


func set_character(value:Character) -> void:
    if value != character:
        character = value
        emit_changed()
    
        if character:
            set_deferred("display_name", character.display_name)
    
    property_list_changed_notify()

##########
## Private
##########

func _show_text() -> void:
    event_node.show()
    _dialog_manager.display_text()


func _prepare_text_to_show() -> void:
    _dialog_manager.show()

    var final_text := ""

    if translation_key != SAME_AS_TEXT:
        final_text = tr(translation_key)

    if continue_previous_text:
        _dialog_manager.add_text(final_text)
    else:
        _dialog_manager.set_text(final_text)
    
    _dialog_manager.text_speed = text_speed


func _configure_display_name() -> void:
    var name_node:Label = event_node.name_node
    if not is_instance_valid(name_node):
        return
    
    if display_name != "":
        name_node.show()

    if character:
        name_node.add_color_override("font_color", character.color)
    
    name_node.text = display_name


func _configure_sound_generator() -> void:
    if blip_sounds.empty():
        # No sounds to play, no need to do anything
        return
    
    _dialog_manager.connect("character_displayed", self, "_on_character_displayed")

    if not is_instance_valid(sound_generator):
        sound_generator = AudioStreamPlayer.new()
    
    if not sound_generator.is_inside_tree():
        event_node.add_child(sound_generator)
    
    sound_generator.bus = blip_audio_bus
    sound_generator.stream = blip_sounds[_generator.randi_range(0, blip_sounds.size())] as AudioStream


func _will_loop_next_time() -> bool:
    return !blip_loop


func _blip() -> void:
    if not sound_generator.is_playing() or blip_force:
        sound_generator.play()


func _on_character_displayed(character:String) -> void:
    if not _already_played:
        _blip()
        _already_played = _will_loop_next_time()


func _on_text_displayed() -> void:

    if is_instance_valid(sound_generator):
        sound_generator.queue_free()
    
    if _dialog_manager.is_connected("character_displayed", self, "_on_character_displayed"):
        _dialog_manager.disconnect("character_displayed", self, "_on_character_displayed")
    
    finish()


func _execute() -> void:
    event_node = event_node as DialogNode
    if not is_instance_valid(event_node):
        finish()
        return
    
    _dialog_manager = event_node.dialog_manager as DialogManager
    if not is_instance_valid(_dialog_manager):
        finish()
        return
    
    _dialog_manager.connect("text_displayed", self, "_on_text_displayed", [], CONNECT_ONESHOT)

    _configure_display_name()
    _configure_sound_generator()
    _prepare_text_to_show()
    _show_text()


func _init() -> void:
    event_color = Color("2892D7")
    event_name = "Text"
    event_icon = load("res://addons/textalog/assets/icons/event_icons/text_bubble.png") as Texture
    event_preview_string = "{displayed_name}: {text}"

    blip_sounds = []