# Info <!-- omit in toc -->

This is a work in progress. This documentation will be updated... Eventually.

There's a block diagram explaining (kind of) the behaviour of this plugin. You can see it [here](https://drive.google.com/file/d/1IVw4dQ4MF7A7okPIngVE0gdJaR8-kzDi/view?usp=sharing)

There's also a [Trello board](https://trello.com/b/pVz78Ct0) with the planned features to be implemented.

They're in spanish.

- [About the documentation](#about-the-documentation)
- [Folder structure](#folder-structure)
  - [addons/](#addons)
    - [dialog_plugin/](#dialog_plugin)
      - [assets/](#assets)
      - [Core/](#core)
      - [Database/](#database)
      - [Editor/](#editor)
      - [Nodes/](#nodes)
      - [Other/](#other)
      - [Resources/](#resources)
  - [dialog_files/](#dialog_files)

# About the documentation

The documentation contains the related information about the different classes and resources that Dialog plugin uses. Tutorials about their use and applications are planned.

# Folder structure

## addons/

Contains your plugins

### dialog_plugin/
Contains every file that the plugin uses

#### assets/
Contains program images, fonts and themes. It also contains example assets that can be used.

#### Core/
Core files, containing every class script.

#### Database/
Resources that contains information about the plugin and your files.

#### Editor/
Every scene that is used to display the Dialog Editor Tab.

#### Nodes/
Base nodes that can be used in the editor, and nodes used in game.

#### Other/
Miscelaneous folder.

#### Resources/
Resources scripts used in the editor

## dialog_files/

Contains your dialog files, wich includes:
- Your `DialogTimelinesesource` timelines
- Your `DialogCharacterResource` characters
- Your themes
- Your custom events