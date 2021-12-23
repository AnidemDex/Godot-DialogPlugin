# Textalog - A DialogSystem Plugin for Godot Engine
[![Godot Engine](https://img.shields.io/badge/Godot%20Engine-Plugin-blue?style=flat-square&logo=godot-engine&logoColor=white&logoWidth=20)]() [![GitHub license](https://img.shields.io/github/license/AnidemDex/Godot-DialogPlugin?style=flat-square)](https://github.com/AnidemDex/Godot-DialogPlugin/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/AnidemDex/Godot-DialogPlugin?style=flat-square)](https://github.com/AnidemDex/Godot-DialogPlugin/issues)
[![Godot Engine](https://img.shields.io/badge/Version-1.0-Green?style=flat-square)](https://github.com/AnidemDex/Godot-DialogPlugin/releases/tag/v1.0)

<p align="center">
  <a href="https://twitter.com/anidemdex" target="_blank"><img src="https://raw.githubusercontent.com/AnidemDex/Godot-DialogPlugin/main/.images/banner_animation.gif"></a><br/>
  Twitter: <a href="https://twitter.com/anidemdex" target="_blank">@AnidemDex</a>
</p>

An user-friendly dialog system for Godot Engine with characters, text boxes, dialog bubbles and many more (planned) features for your games. 

> **Note:** _If you find a bug, or want a feature to be included, feel free to [open a new issue](https://github.com/AnidemDex/Godot-DialogPlugin/issues/new). You can also send me a message on [twitter](https://twitter.com/anidemdex) or [join us on Discord](https://discord.gg/83YgrKgSZX)._

## Features
### 🪧 DialogNode and 🗨️ DialogBubble
A node implementation for dialog box and dialog bubble, fully customizable and build with common dialog commands to improve your game development in the dialogue interaction.

- DialogNode
![DialogNode](./docs/.gitbook/assets/dialog_box_example_1.png)

- DialogBubble
<p align="center">
  <img src="./docs/.gitbook/assets/dialog_bubble_example_1.png">
</p>

### 🐱‍👤 Characters and 🖼️ Portraits
Characters are data containers to describe what expressions (portraits) are going to be used in dialogue and what properties of the dialogue will be overriden during the gameplay.

![character editor](./docs/.gitbook/assets/character_example1.png)

### 🎨 Customization through Godot's Themes
Modify the DialogNode through themes!

![Theme Customization](./docs/.gitbook/assets/theme_customization.gif)

### Use it as a Dialog System!
The plugin can help you creating sequences of dialogs and dialog branches to certain conditions, all in the editor, thanks to its integration with [EventSystem](https://github.com/AnidemDex/Godot-EventSystem).

![](docs/.gitbook/assets/event_system_example1.png)

You can create the entire dialog sequence through code too!

![](docs/.gitbook/assets/event_system_example2.png)

See more about this implementation on [the documentation](#).

## 🚩 Installation

Download the lastest release and extract the ZIP file. Move the `addons` folders to the root of your project. Finally, enable the plugin in your project settings, under `plugins` tab. It's that easy!

> You can take a look in a more detailed tutorial in the [plugin's documentation](https://godotplugins.gitbook.io/textalog/getting-started/installation).
If you want more information about installing plugins in Godot, please refer to [official documentation page](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html).

If you're downloading the repository instead, make sure to move only `textalog` to your `addons` folder. Extra files and folders are for debug purposes.

## 🧵 Usage
Quick example to try the most simple functionality: showing text on the screen.
```gdscript
extends Node

func _ready() -> void:
  # Creates a new DialogNode instance
  var dialog_node = DialogNode.instance()
  # Add the node as child
  add_child(dialog_node)

  # Show an string. BBCode works too!
  dialog_node.show_text("Hello world!")
```

> ⚠️ `Control` node and `Node2D` node types are incompatible. If you want to add the `DialogNode` as child of a Node2D type, make sure to give it a proper `rect_size`, add it as child of a `CanvasLayer` or add it in the scene, not in code.



## 🔎 What is new on this version? [1.1]

Second release! Who would think about it?
The most relevant about this update is its reintegration with EventSystem, to use it as a Dialog System again! 🎉

* Added:
  * **Reference hint in PortraitManager.** Now the reference rect node that were used previously is built-in directly on the node, letting you modify it directly in PortraitManager.
  * **Integration with EventSystem.** Use Textalog not only as a Dialog Node, but as a Dialog System too [#56](https://github.com/AnidemDex/Godot-DialogPlugin/pull/56).
* Changed:
  * **`DialogManager.text_autoscroll` will be false by default.**
  * **`DialogManager.text_fit_content_height` will be false by default.**
* Removed:
  * **ReferenceRect node from PortraitManager.**

Want to see the whole changelog? Take a look on the documentation, the [Changelog](https://anidemdex.gitbook.io/godot-dialog-plugin/changelog) section.

## 📚 Documentation

Now we have an official documentation! All the information about the plugin you will find it organized in the [documentation page](https://godotplugins.gitbook.io/textalog/). Tutorials, class information, FAQ and more will be added there, eventually.

## 📝Credits and license
Made by [AnidemDex](https://github.com/anidemDex)

This plugin uses [MIT license](./LICENSE)
