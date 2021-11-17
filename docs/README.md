# 🧐 What is Textalog?

[![Godot Engine](https://img.shields.io/badge/Godot%20Engine-Plugin-blue?style=flat-square\&logo=godot-engine\&logoColor=white\&logoWidth=20)](./) [![GitHub license](https://img.shields.io/github/license/AnidemDex/Godot-DialogPlugin?style=flat-square)](../LICENSE/) [![GitHub issues](https://img.shields.io/github/issues/AnidemDex/Godot-DialogPlugin?style=flat-square)](https://github.com/AnidemDex/Godot-DialogPlugin/issues) [![Godot Engine](https://img.shields.io/badge/Version-1.0-Green?style=flat-square)](https://github.com/AnidemDex/Godot-DialogPlugin/releases/tag/v1.0)

![](https://raw.githubusercontent.com/AnidemDex/Godot-DialogPlugin/main/.images/banner\_animation.gif)

An user-friendly dialog system for Godot Engine with characters, text boxes, dialog bubbles and many more (planned) features for your games.

{% hint style="info" %}
_If you find a bug, or want a feature to be included, feel free to _[_open a new issue_](https://github.com/AnidemDex/Godot-DialogPlugin/issues/new)_. You can also send me a message on _[_twitter_](https://twitter.com/anidemdex)_ or _[_join us on Discord_](https://discord.gg/83YgrKgSZX)_._
{% endhint %}

## Features

### 🪧 DialogNode and 🗨️ DialogBubble

A node implementation for dialog box and dialog bubble, fully customizable and build with common dialog commands to improve your game development in the dialogue interaction.

#### 🪧 DialogNode

![](.gitbook/assets/dialog\_box\_example\_1.png)

#### 🗨️ DialogBubble

![](.gitbook/assets/dialog\_bubble\_example\_1.png)

### 🐱‍👤 Characters and 🖼️ Portraits

Characters are data containers to describe what expressions (portraits) are going to be used in dialogue and what properties of the dialogue will be overriden during the gameplay.

## 🧵 Usage

Quick example to try the most simple functionality: showing text on the screen.

```gdscript
func _ready() -> void:
  # Creates a new DialogNode instance
  var dialog_node = DialogNode.instance()

  # Add the node as child
  add_child(dialog_node)

  # Shows the dialog node
  dialog_node.show()

  # Show an string. BBCode works too!
  dialog_node.show_text("Hello world!")
```

## 🚩Getting Started

{% content-ref url="getting-started/installation.md" %}
[installation.md](getting-started/installation.md)
{% endcontent-ref %}

## 📝Credits and license

Made by [AnidemDex](https://github.com/anidemDex)

This plugin uses [MIT license](../LICENSE/)
