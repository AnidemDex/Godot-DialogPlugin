# Installing Textalog

{% hint style="info" %}
If you want more information about installing plugins in Godot, please check the [official documentation](https://docs.godotengine.org/es/stable/tutorials/plugins/editor/installing\_plugins.html).
{% endhint %}

## Download

There are several options for downloading the plugin. The method you use will only influence the version to be downloaded.

### Option A: Stable version from the repository

![Option A](../.gitbook/assets/tutorial\_option\_a.png)

Download the latest stable version released from the repository.

![](../.gitbook/assets/tutorial\_option\_a\_1.png)

Click on `Textalog_v?.zip` where `?` will be the version number. It will start downloading a compressed file, which contains the plugin files.

### Option B: Latest untested version from the repository

![Option B](../.gitbook/assets/tutorial\_option\_b.png)

{% hint style="warning" %}
This type of version is often referred to by a name similar to _neutral version_, and refers to versions that are on the current state of version control.

This does not mean that it is working or usable. If the current state of the repository included some change that caused the plugin to start crashing, neutral version will also crash.
{% endhint %}

This download allows you to download an untested version from the repository, which is with the latest features added to the plugin (again, still untested). It is not recommended for use.

### Option C: Stable version from AssetLib

Go to AssetLib section inside Godot Editor.

Search for `Textalog` and click on the plugin. Then, click on download.

### Option D: Using git
If you're already using a version control with git to your project, you can add Textalog to your commit log as a `subtree` or merge it from the repo with a `sparse checkout`.

Add the repository as a remote reference in your current repository.

```
git remote add textalog https://github.com/AnidemDex/Godot-DialogPlugin.git
```

## Installation

The installation of the plugin may vary depending on the option you chose to download the plugin.

### Option A and B

![](../.gitbook/assets/tutorial\_installing\_from\_zip.png)

Extract the `addons` folder to the root of the folder where your project is located.

## Enable the plugin

In the project settings, in the `Plugin` tab check the `Enable` box.

![](../.gitbook/assets/tutorial\_enabling.png)


Download the lastest release and extract the ZIP file. Move the `addons` folders to the root of your project. Finally, enable the plugin in your project settings, under `plugins` tab. It's that easy!

> You can take a look in a more detailed tutorial in the [plugin's documentation](https://godotplugins.gitbook.io/textalog/getting-started/installation).

If you want more information about installing plugins in Godot, please refer to [official documentation page](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing\_plugins.html).

If you're downloading the repository instead, make sure to move only `textalog` to your `addons` folder. Extra files and folders are for debug purposes.
