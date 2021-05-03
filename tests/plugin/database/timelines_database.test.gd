extends WAT.Test

const TimelineDatabaseResource = preload("res://addons/dialog_plugin/Resources/Database/TimelineDatabaseResource.gd")

var database
var _path = "res://addons/dialog_plugin/Database/SavedTimelines.tres"

func title() -> String:
	return "With TimelineDatabase"


func pre() -> void:
	database = ResourceLoader.load(_path)


func pos() -> void:
	database.resources = null
	database = null


func test_if_the_database_exist() -> void:
	asserts.file_exists(_path)


func test_if_the_database_is_database_resource() -> void:
	asserts.is_class_instance(database, DialogDatabaseResource, "Is DatabaseResource")


func test_if_is_timeline_database() -> void:
	asserts.is_class_instance(database, TimelineDatabaseResource, "Is TimelineDatabaseResource")


func test_if_the_timeline_database_is_empty() -> void:
	asserts.is_equal(database.resources.get_resources().size(), 0, "The timeline is empty")
	

func test_when_add_timeline() -> void:
	var _res = DialogTimelineResource.new()
	database.add(_res)
	asserts.is_true(_res in database.resources.get_resources(), "The resource was added")
	database.remove(_res)
	_res = null

func test_when_remove_timeline() -> void:
	var _res = DialogTimelineResource.new()
	database.add(_res)
	if _res in database.resources.get_resources():
		database.remove(_res)
		asserts.is_false(_res in database.resources.get_resources(), "The resource was removed")
	else:
		asserts.fail("The resource wasn't removed")
	_res = null
