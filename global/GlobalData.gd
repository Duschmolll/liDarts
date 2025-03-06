extends Node

const SAVE_DIR = "user://data/"
const SAVE_FILE_NAME = "data.json"
const SECURITY_KEY = "0EZASQ"

var playerList: Array[Player] = []
var playerSelected: Array[Player] = []
var setting = {}
var data_loaded = false

func _ready() -> void:
	verify_save_dir(SAVE_DIR)
	GlobalData.setting['x01'] = X_01_Settings.new()
	load_data(SAVE_DIR + SAVE_FILE_NAME)


func verify_save_dir(path: String) -> void:
	DirAccess.make_dir_absolute(path)


func save_data(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		printerr(FileAccess.get_open_error())
		return
	
	var globalPlayer = []
	var globalPlayerSelected = {}
	var globalSetting = {}
	
	if len(self.playerList) > 0:
		for elem: Player in self.playerList:
			globalPlayer.append(elem.export())
			
	if len(self.playerSelected) > 0:
		for elem in self.playerSelected:
			globalPlayerSelected = {
				'name' = elem.name,
				'flag' = elem.flag
			}
	
	if len(self.setting.keys()) > 0:
		for key in self.setting.keys():
			var current_setting = self.setting[key]
			globalSetting[key] = {
				'score' = current_setting.score,
				'total_leg' = current_setting.total_leg,
				'total_set' = current_setting.total_set,
				'double_in' = current_setting.double_in,
				'double_out' = current_setting.double_out,
				'show_check_out' = current_setting.show_check_out
			}
	
	var data = {
		"playerList" = globalPlayer,
		"playerSelected" = globalPlayerSelected,
		"setting" = globalSetting
		}
		
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()
	print("Saved")


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
		
		for elem in data.playerSelected:
			self.playerSelected.append(Player.new())
			self.playerSelected[-1].newPlayer(elem.name, elem.flag)
		
		var current_setting = data.setting['x01']
		self.setting['x01'] = X_01_Settings.new()
		self.setting['x01'].score = current_setting.score
		self.setting['x01'].total_leg = current_setting.total_leg
		self.setting['x01'].total_set = current_setting.total_set
		self.setting['x01'].double_in = current_setting.double_in
		self.setting['x01'].double_out = current_setting.double_out
		self.setting['x01'].show_check_out = current_setting.show_check_out
		print("Data has been loaded")
	else:
		printerr("Cannot open non-existant file at %s!" % [path])
