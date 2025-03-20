extends Node

const SAVE_DIR = "user://data/"
const SAVE_FILE_NAME = "data.json"
const SECURITY_KEY = "0EZASQ"

## List of the different player saved.
var playerList: Array[Player] = []
## Setting dictionary to save the differentes type of settings.
var setting = {}
## Bool to check if the data as been loaded.
var data_loaded = false
## gameSelected is used for loading the right scene when an user as selected his playerList
var gameSelected

func _ready() -> void:
	verify_save_dir(SAVE_DIR)
	GlobalData.setting['x01'] = X01Settings.new()
	load_data(SAVE_DIR + SAVE_FILE_NAME)

## Verify if the save path is valid.
func verify_save_dir(path: String) -> void:
	DirAccess.make_dir_absolute(path)

## Save the data into a JSON file.
func save_data(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		printerr(FileAccess.get_open_error())
		return
	
	var globalPlayer = []
	var globalSetting = {}
	
	if len(self.playerList) > 0:
		for elem: Player in self.playerList:
			globalPlayer.append(elem.export())
			

	
	if len(self.setting.keys()) > 0:
		for key in self.setting.keys():
			globalSetting[key] = self.setting[key].exportDict()
	
	var data = {
		"playerList" = globalPlayer,
		"setting" = globalSetting
		}
		
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()
	print("Saved")

## Load the data from a JSON file
func load_data(path: String) -> void:
	if data_loaded:
		return
	else:
		data_loaded = true
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path,FileAccess.READ)
		if file == null:
			printerr(FileAccess.get_open_error())
			return
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannot parse %s as a json_string: (%s)!" % [path, content])
			return
		
		for elem in data.playerList:
			self.playerList.append(Player.new())
			self.playerList[-1].import(elem)
		
		for elem in data.setting.keys():
			match data.setting[elem].type:
				"X01":
					self.setting.X01 = X01Settings.new()
					self.setting.X01.importDict(data.setting[elem])

		print("Data has been loaded")
	else:
		printerr("Cannot open non-existant file at %s!" % [path])
