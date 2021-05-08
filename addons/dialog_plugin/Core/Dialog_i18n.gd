tool

const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")
const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")

static func load_editor_translations() -> void:
	var editor_i18n:Array = (load(DialogResources.EDITOR_i18n_PATH) as DialogDatabaseResource).resources.get_resources()
	for translation in editor_i18n:
		TranslationService.add_translation(translation)


static func remove_editor_translations() -> void:
	var editor_i18n:Array = (load(DialogResources.EDITOR_i18n_PATH) as DialogDatabaseResource).resources.get_resources()
	for translation in editor_i18n:
		TranslationService.remove_translation(translation)


static func load_translations() -> void:
	var _translations:Array = Array(load(DialogResources.TRANSLATIONSDB_PATH).resources.get_resources())
	for translation in _translations:
		TranslationService.add_translation(translation)


static func export_translations_as_csv() -> void:
	var _translations:Array = Array(load(DialogResources.TRANSLATIONSDB_PATH).resources.get_resources())
	for translation in _translations:
		translation = translation as Translation
		
		var translation_file_name = (translation.resource_path as String).get_file().split(".")[0]
		var translation_file_extension = ".csv"
		var translation_file_path = DialogResources.TRANSLATIONS_DIR+translation_file_name+translation_file_extension
		
		var file = File.new()
		var _err:int
		
		if file.file_exists(translation_file_path):
			file.open(translation_file_path, file.READ)
		else:
			file.open(translation_file_path, file.WRITE_READ)
		
		if _err == OK:
			# Save old keys
			var csv_keys:Array = Array(file.get_csv_line())
			var csv_content:Array = []
			var csv_translation_keys:Array = []
			
			# Save old data in the file
			while not file.eof_reached():
				var line = Array(file.get_csv_line())
				if not line.empty():
					if line.size() == 1 and line[0] == "":
						continue
					csv_content.append(line)
			
			if not "key" in csv_keys:
				csv_keys[0] = "key"
			if not translation.locale in csv_keys:
				csv_keys.append(translation.locale)
			
			file.close()
			
			# Save a reference for xlation keys
			for line in csv_content:
				if line.size() == 1 and line[0] == "":
						continue
				csv_translation_keys.append(line[0])
			
			# For key ID in the translation file
			for t_key in translation.get_message_list():
				var t_key_position = csv_translation_keys.find(t_key)
				var locale_position = csv_keys.find(translation.locale)
				
				if t_key_position != -1:
					# They key exist, replace its content
					var line = csv_content[t_key_position]
					if locale_position >= line.size():
						while locale_position >= line.size():
							line.append("")
					line[locale_position] = translation.get_message(t_key)
				else:
					# The key doesn't exist, create one
					var line = [t_key]
					for locale in csv_keys.size()-1:
						line.append(" ")
					line[locale_position] = translation.get_message(t_key)
					csv_content.append(line)
			
			
			_err = file.open(translation_file_path, file.WRITE)
			
			if _err == OK:
				# Save the keys
				file.store_csv_line(csv_keys)
				
				# Save all the content
				for line in csv_content:
					file.store_csv_line(line)
				
				file.close()
		
		# Force the importer to not compress the translations
		# This had to be this way while PHashTranslation get fixed
		var import_config = ConfigFile.new()
		_err = import_config.load(translation_file_path)
		assert(_err == OK)
		import_config.set_value("params", "compress", false)
		import_config.save(translation_file_path+".import")
		assert(_err == OK)
