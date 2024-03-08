extends Control

const SAVE_DIR = "user://saves/"
const SAVE_FILE_NAME = "datasaved.json"
const SECURITY_KEY = "0EZASQ"

var global_data: GlobalData = GlobalData.new()

@onready var canvas: CanvasLayer = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas# Replace with function body.

# Called when the node enters the scene tree for the first time.
func _ready():
	print(self.get_path())
	verify_save_dir(SAVE_DIR)
	load_data(SAVE_DIR + SAVE_FILE_NAME) # Replace with function body.

	_createPlayerList()
	
func verify_save_dir(path: String):
	DirAccess.make_dir_absolute(path)
	
func save_data(path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		print("Null")
		print(FileAccess.get_open_error())
		return
	var global_player = {}
	print("global_data.number_of_player: " + str(global_data.number_of_player))
	if global_data.number_of_player > 0:
		print('Test')
		for i in range(1, global_data.number_of_player + 1):
			var current_player = global_data.player_list["player_"+str(i)]
			global_player["player_"+str(i)] = {
				'name' = current_player.name
			}
			print("ezmkajeazmkejzamea")
			print("The Current Player: " + current_player.name)
		
	var data = {
		"global_data" = {
			"number_of_player" = global_data.number_of_player,
			"player_list" = global_player
		}
	}
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()
	print("Saved")

func load_data(path: String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path,FileAccess.READ)
		if file == null:
			print(FileAccess.get_open_error())
			return
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannot parse %s as a json_string: (%s)!" % [path, content])
			return
			
		global_data.number_of_player = int(data.global_data.number_of_player)
		global_data.player_list = data.global_data.player_list
		print(global_data.player_list)
		for i in range(1, global_data.number_of_player + 1):
			var temp = global_data.player_list["player_" + str(i)]
			global_data.player_list["player_" + str(i)] = Player.new()
			global_data.player_list["player_" + str(i)].name = temp.name
		print(global_data.player_list["player_1"].name)
	else:
		printerr("Cannot open non-existant file at %s!" % [path])
		

func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")

func _on_new_player_pressed():
	if canvas.visible:
		canvas.visible = false
	else: 
		canvas.visible = true
		
func _createPlayerList():
	var grid = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/PlayerListContainer/PanelContainer/MarginContainer/PlayerListControl/PlayerListGrid
	const PLAYER_LIST = preload("res://player_list.tscn")
	if global_data.number_of_player > 0:
		for i in range(1, global_data.number_of_player + 1):
			var instance = PLAYER_LIST.instantiate()
			grid.add_child(instance)
			grid.get_children()[i-1].get_children()[0].get_children()[0].get_children()[1].text = global_data.player_list["player_" + str(i)].name
		print(self.get_children()[0])
	
func _on_button_pressed():
	var player: Player = Player.new()
	var name_line: LineEdit = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas/PanelContainer/ColorRect/MarginContainer/CreatePlayer/HBoxContainer/LineEdit
	var name: String = name_line.text
	var re = RegEx.new()
	re.compile("[\\d\\s]+")
	var result = re.search(name)
	#print(len(name))
	if len(name) > 3:
		if result:
			if result.get_string() != "" || name == "":
				name_line.clear()
				name_line.placeholder_text= "Invalid Name"
				print("Wrong: " + name) 
		else:
			print("All good: " + name)
			global_data.player_list['player_'+str(global_data.number_of_player + 1)] = Player.new()
			global_data.player_list["player_"+str(global_data.number_of_player + 1)].name = name
			print("Player Name: " + global_data.player_list["player_"+str(global_data.number_of_player + 1)].name)
			#print(global_data.player_list)
			global_data.number_of_player += 1
			#print(global_data.number_of_player)
			save_data(SAVE_DIR + SAVE_FILE_NAME)
			canvas.visible = false
	else:
		name_line.clear()
		name_line.placeholder_text= "Name too short"



