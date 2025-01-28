extends Node

const SAVE_DIR = "user://data/"
const SAVE_FILE_NAME = "data.json"
const SECURITY_KEY = "0EZASQ"

var player_list = {}
var player_selected = {}
var setting = {}
var data_loaded = false

func _ready():
	verify_save_dir(SAVE_DIR)
	GlobalData.setting['x01'] = X_01_Settings.new()
	load_data(SAVE_DIR + SAVE_FILE_NAME)


func verify_save_dir(path: String):
	DirAccess.make_dir_absolute(path)


func save_data(path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		printerr(FileAccess.get_open_error())
		return
	var global_player = {}
	var global_player_selected = {}
	var global_setting = {}
	
	if len(GlobalData.player_list.keys()) > 0:
		for key in GlobalData.player_list.keys():
			var current_player = GlobalData.player_list[key]
			global_player[key] = {
				'name' = current_player.name,
				'flag' = current_player.flag,
				'all_time_average_per_leg' = current_player.all_time_average_per_leg,
				'all_time_average_per_throw' = current_player.all_time_average_per_throw,
				'all_time_throw' = current_player.all_time_throw,
				'all_time_dart' = current_player.all_time_dart,
				'all_time_score_80' = current_player.all_time_score_80,
				'all_time_score_100' = current_player.all_time_score_100,
				'all_time_score_140' = current_player.all_time_score_140,
				'all_time_score_180' = current_player.all_time_score_180,
				'all_time_leg' = current_player.all_time_leg,
				'all_time_leg_win' = current_player.all_time_leg_win,
				'all_time_total_score' = current_player.all_time_total_score
			}
				
	if len(GlobalData.player_selected.keys()) > 0:
		for key in GlobalData.player_selected.keys():
			var current_player = GlobalData.player_selected[key]
			global_player_selected[key] = {
				'name' = current_player.name,
				'flag' = current_player.flag
			}
	
	if len(GlobalData.setting.keys()) > 0:
		for key in GlobalData.setting.keys():
			var current_setting = GlobalData.setting[key]
			global_setting[key] = {
				'score' = current_setting.score,
				'total_leg' = current_setting.total_leg,
				'total_set' = current_setting.total_set,
				'double_in' = current_setting.double_in,
				'double_out' = current_setting.double_out,
				'show_check_out' = current_setting.show_check_out
			}
	var data = {
		"global_data" = {
			"player_list" = global_player,
			"player_selected" = global_player_selected,
			"setting" = global_setting
		}
	}
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()
	print("Saved")


func load_data(path: String):
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
			
		GlobalData.player_list = data.global_data.player_list
		
		for key in data.global_data.player_list.keys():
			var current_player = data.global_data.player_list[key]
			GlobalData.player_list[key] = Player.new()
			GlobalData.player_list[key].name = current_player.name
			GlobalData.player_list[key].flag = current_player.flag
			GlobalData.player_list[key].all_time_average_per_leg = current_player.all_time_average_per_leg
			GlobalData.player_list[key].all_time_average_per_throw = current_player.all_time_average_per_throw
			GlobalData.player_list[key].all_time_throw = current_player.all_time_throw
			GlobalData.player_list[key].all_time_dart = current_player.all_time_dart
			GlobalData.player_list[key].all_time_score_80 = current_player.all_time_score_80
			GlobalData.player_list[key].all_time_score_100 = current_player.all_time_score_100
			GlobalData.player_list[key].all_time_score_140 = current_player.all_time_score_140
			GlobalData.player_list[key].all_time_score_180 = current_player.all_time_score_180
			GlobalData.player_list[key].all_time_leg = current_player.all_time_leg
			GlobalData.player_list[key].all_time_leg_win = current_player.all_time_leg_win
			GlobalData.player_list[key].all_time_total_score = current_player.all_time_total_score
		
		for key in data.global_data.player_selected.keys():
			var current_player = data.global_data.player_selected[key]
			GlobalData.player_selected[key] = Player.new()
			GlobalData.player_selected[key].name = current_player.name
			GlobalData.player_selected[key].flag = current_player.flag
		
		var current_setting = data.global_data.setting['x01']
		GlobalData.setting['x01'] = X_01_Settings.new()
		GlobalData.setting['x01'].score = current_setting.score
		GlobalData.setting['x01'].total_leg = current_setting.total_leg
		GlobalData.setting['x01'].total_set = current_setting.total_set
		GlobalData.setting['x01'].double_in = current_setting.double_in
		GlobalData.setting['x01'].double_out = current_setting.double_out
		GlobalData.setting['x01'].show_check_out = current_setting.show_check_out
		print("Data has been loaded")
	else:
		printerr("Cannot open non-existant file at %s!" % [path])
