tool
extends PanelContainer

signal event_pressed(event)

export(PackedScene) var category:PackedScene
export(NodePath) var DummyContainer:NodePath

var categories:Dictionary = {}

onready var categories_container:Control = get_node(DummyContainer) as Control


func add_event(event_script:Script) -> void:
	var event:Resource = event_script.new()
	var event_category:String = str(event.get("event_category"))
	
	if not(event_category in categories):
		add_category(event_category)
	
	var category_node = categories[event_category]
	category_node.call("add_event", event)


func add_category(category_name:String) -> void:
	var category_node:Node = category.instance()
	var separator = VSeparator.new()
	category_node.set("category", category_name)
	category_node.connect("ready", category_node, "_fake_ready")
	category_node.connect("event_pressed", self, "_on_EventButton_pressed")
	
	categories[category_name] = category_node
	
	categories_container.add_child(category_node)
	categories_container.add_child(separator)


func clear_all() -> void:
	categories = {}
	for child in categories_container.get_children():
		child.queue_free()


func _on_EventButton_pressed(event_script:Script) -> void:
	emit_signal("event_pressed", event_script.new())
