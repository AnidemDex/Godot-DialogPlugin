# Textalog - A DialogSystem Plugin for Godot Engine
[![Godot Engine](https://img.shields.io/badge/Godot%20Engine-Plugin-blue?style=flat-square&logo=godot-engine&logoColor=white&logoWidth=20)]() [![GitHub license](https://img.shields.io/github/license/AnidemDex/Godot-DialogPlugin?style=flat-square)](https://github.com/AnidemDex/Godot-DialogPlugin/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/AnidemDex/Godot-DialogPlugin?style=flat-square)](https://github.com/AnidemDex/Godot-DialogPlugin/issues)
[![Godot Engine](https://img.shields.io/badge/Version-1.0-Green?style=flat-square)](https://github.com/AnidemDex/Godot-DialogPlugin/releases/tag/v1.0)

<p align="center">
  <a href="https://twitter.com/anidemdex" target="_blank"><img src="https://raw.githubusercontent.com/AnidemDex/Godot-DialogPlugin/main/.images/banner_animation.gif"></a><br/>
  Twitter: <a href="https://twitter.com/anidemdex" target="_blank">@AnidemDex</a>
</p>

A dialog `Node` implementation for Godot Engine, aiming to be a node that fits the majority of use cases where a dialog node is needed for any kind of game.

> **We're working hardly on 2.0 version.** This means that the latest commit from repository is probably not production ready to use. Make sure to download the plugin from the releases section.

## Features
### 🪧 DialogNode
A node implementation for make dialogs, fully customizable and built with common dialog commands to improve your game development in the dialogue interaction. Create dialog bubbles, dialog boxes and anything that has _dialog_ on its name!

[!TODO: Add dialog box with options example](#)
[!TODO: Add dialog bubble example](#)

### 🐱‍👤 Characters and 🖼️ Portraits
Characters are data containers to describe what expressions (portraits) are going to be used in dialogue and what properties of the dialogue will be overriden during the gameplay.

![TODO: Update character editor image](#)

### Easy \*blip* sounds.
The plugin has tools that will help you to integrate audio in your dialogs, either single blip sounds or complex and large voice acted lines.

![TODO: Add a video with a blip example](#)

### 🎨 Customization through Godot's Themes
Because every game is unique as their creators, we let the possibility to modify the DialogNode through themes, to make it unique as you.

![TODO: Update customization gif](#)

### Easy to integrate in your Dialog System
Textalog was made as a single node, agnostic to whatever your text is on. Give the node the data, it will create the dialog in screen for you.

### You don't have a dialog system? Use Textalog as a Dialog System!
The plugin can help you creating sequences of dialogs and dialog branches to certain conditions, all in the editor, thanks to its integration with [EventSystem](https://github.com/AnidemDex/Godot-EventSystem).

![](docs/.gitbook/assets/event_system_example1.png)

You can create the entire dialog sequence through code too!

![](docs/.gitbook/assets/event_system_example2.png)

See more about this implementation on [the documentation](#).

## 🚩 Installation

### Manually
Download the lastest release and extract the ZIP file. Move the resulting folder to your `addons` folder (create one at the root of your project if it doesn't exist). Finally, enable the plugin in your project settings, under `plugins` tab. It's that easy!

> You can take a look in a more detailed tutorial in the [plugin's documentation](https://godotplugins.gitbook.io/textalog/getting-started/installation).
If you want more information about installing plugins in Godot, please refer to [official documentation page](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html).

### As `submodule`
```bash
git submodule add https://github.com/AnidemDex/Godot-DialogPlugin.git addons/dialog_plugin
```

## 🧵 Usage
Quick example to try the most simple functionality: showing text on the screen.
```gdscript
extends Node

func _ready() -> void:
  # Creates a new DialogNode instance
  var dialog_node = DialogNode.new()
  # Add the node as child
  add_child(dialog_node)

  # Show an string. BBCode works too!
  dialog_node.show_text("Hello world!")
```

> ⚠️ `Control` node and `Node2D` node types are incompatible. If you want to add the `DialogNode` as child of a Node2D type, make sure to give it a proper `rect_size`, add it as child of a `CanvasLayer` or add it in the scene, not in code.

## 📚 Documentation

Now we have an official documentation! All the information about the plugin you will find it organized in the [documentation page](https://godotplugins.gitbook.io/textalog/). Tutorials, class information, FAQ and more will be added there, eventually.

## ⏱️Changelog
Changelog lives on [Changelog](https://anidemdex.gitbook.io/godot-dialog-plugin/changelog) section from [Documentation](#📚-documentation).

## Contributing
Contributions are welcome and very appreciated. You can open issues to request something or report bugs or create pull request to integrate something new or solve an issue.
Take a look at [Contributing](https://github.com/AnidemDex/Godot-DialogPlugin/blob/main/CONTRIBUTING.md) file.