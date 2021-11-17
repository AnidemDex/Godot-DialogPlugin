# 🧐 What is Textalog?

<p align="center">
  <a href="https://twitter.com/anidemdex" target="_blank"><img src="https://raw.githubusercontent.com/AnidemDex/Godot-DialogPlugin/main/.images/banner_animation.gif"></a><br/>
  Twitter: <a href="https://twitter.com/anidemdex" target="_blank">@AnidemDex</a>
</p>

![](https://raw.githubusercontent.com/AnidemDex/Godot-DialogPlugin/main/.images/banner\_animation.gif)

> **Note:** _If you find a bug, or want a feature to be included, feel free to [open a new issue](https://github.com/AnidemDex/Godot-DialogPlugin/issues/new). You can also send me a message on [twitter](https://twitter.com/anidemdex) or [join us on Discord](https://discord.gg/83YgrKgSZX)._

{% hint style="info" %}
_If you find a bug, or want a feature to be included, feel free to _[_open a new issue_](https://github.com/AnidemDex/Godot-DialogPlugin/issues/new)_. You can also send me a message on _[_twitter_](https://twitter.com/anidemdex)_ or _[_join us on Discord_](https://discord.gg/83YgrKgSZX)_._
{% endhint %}

## Features
### 🪧 DialogNode and 🗨️ DialogBubble
A node implementation for dialog box and dialog bubble, fully customizable and build with common dialog commands to improve your game development in the dialogue interaction.

#### 🪧 DialogNode

![](.gitbook/assets/dialog\_box\_example\_1.png)

#### 🗨️ DialogBubble

- DialogBubble
<p align="center">
  <img src="./docs/.gitbook/assets/dialog_bubble_example_1.png">
</p>

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

This plugin uses [MIT license](./LICENSE)
