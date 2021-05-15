# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [UNRELEASED]
### Added
- **Event container in timeline editor**
- **Property `event_editor_scene_path`in EventResource.** Now is more easy to create custom events and point to its editor.
- **Character Leave event.** to make your characters out the conversation, know as `DialogCharacterLeaveEvent`
- **Character Change Expression event.** Know as `DialogCharacterChangeExpressionEvent`
- **Play Audio event.**
- **Stop Audio event.**
- **Jump to event.** Know as `DialogJumpToEvent`
- **Jump to timeline.** Know as `DialogChangeTimelineEvent`
- **Custom event.** Know as `DialogCustomEvent`
- **New property for every EventResource:** `skip`. Now you can decide if the event will continue inmediatly to next event or will wait until the user press a key.
- **OptionButtonGenerator class added.** Is like an OptionButton but with suggar. [Needs documentation and is not avaliable in the global scope]
- **New signal to DialogEditorEventNode.** `timeline_requested`
- **Variables.** 
### Changed
- **Clip content outside the timeline preview.**
- **Event buttons background**
- **Portraits are now treated as expressions in editor.**
- **Portrait ReferenceRect are now useful.** They represent how the portrait may be in game, including position and size.
- **Script templates.** Now with more comments
- **DialogEvent in button events nodes.**Now is more easy to display custom resources. Errors may appear in console due a godot related bug.
### Deprecated
- **Expand and contract animation in event buttons.** The information about the event now had to be a text hint tooltip.
### Removed
- **Floating event container in timeline editor**
- **Override `get_event_editor_node` from EventResource.** Now is more easy to create custom events
### Fixed
- **Character, animation and portrait list giving weird errors on new projects.**
- **Sometimes the editor closes itself with no reason**
- **Character join event doesn't show the last saved portrait position.**


## [0.1.4] - 2021-05-09
### Added
- **Translation system** based on Godot i18n using a [modified version of this repository](https://github.com/AnidemDex/Godot-TranslationService)
- **Translations to text events and timeline editor**. You can use .csv files or use the Dialog editor to create translations.
- **Translations to the plugin itself**. There's more languages than english.
- **CHANGELOG.md file.** Who said that keep the things in order is easy?
  
### Changed
- **Timeline editor view.**
- **Main screen behaviour.** The editor now instances itself only when you select the editor, and free itself if you change the main screen. Keeping free RAM is never easy.

### Fixed
- [Leaked instances on exit.](https://github.com/AnidemDex/Godot-DialogPlugin/issues/1)
- **Translations bug.** For some reason, Godot doesn't brings all properties on a clean project. This tries to workaround that.


## [0.1.3] - 2021-05-03
### Fixed
- **Draggable events fixed**. There was a bug related the drag 'n' drop system


## [0.1.2] - 2021-05-03
### Added
- **Drag 'n' drop system.** You can drag and drop events from the event container, or reorganize your timelines.
- **Test suit added.** Because making mistakes is a human thing, this can prevent making many mistakes verifying the source files. The power of Unit Testing (provided by [WAT plugin](https://github.com/AlexDarigan/WAT-GDScript)) and Github Actions in one place.
- **DialogBaseNode icon.** Because beeing unique is a hard task to do in the actual era.

### Changed
- **Databases now must keep it default values.** Nobody wants to know that i use timelines like "food" or "test".
- **Banner image.** A little witch that gives the welcome is always better.
- **Timeline preview.** With a new theme and behaviour.


## [0.1.1] - 2021-05-01
### Added
- **Documentation about any class that plugin uses.** Have you any idea how many time this took me to do? My soul was drained while I was doing documentation, and it's incomplete.

### Changed
- **Dialog bubble.** Now it looks more like a bubble than a little square.


## [[0.1.0]](https://github.com/AnidemDex/Godot-DialogPlugin/releases/tag/v0.1.0) - 2021-04-30
### Added
- **DialogBaseNode.** The base class to create and use any timeline.
- **In game text box.** For those who wants to make dialogues in squares.
- **In game dialog bubble.** For those who wants to make dialogues but doesn't like squares.
- **Database files.** That holds references to files created by the user.
- **Plugin core files.** Very important.
- **Example assets.** Some of them are used in the base nodes.