extends Control

# Containers:
@export var button_container: Node
@export var dart_input_container: Node
@export var player_01_container: Node
@export var player_02_container: Node
# Label:
@export var dart_1_label: Node
@export var dart_2_label: Node
@export var dart_3_label: Node

# Variables: 
var dart_1_value_check: bool = false
var dart_2_value_check: bool = false
var dart_3_value_check: bool = false
var number_of_leg = 1
var total_of_turn = 1

var setting = X_01_Settings.new()
var player_01: String 
var player_02: String 
var list_player: Array[String]
var key: Array

func _ready():
	GlobalData.load_data("user://data/data.json")
	key = GlobalData.player_selected.keys()
	# Set-in functions for all buttons:
	for btn in button_container.get_children():
		if btn.text.is_valid_int():
			btn.pressed.connect(Callable(self, "_number_buttons").bind(btn))
		else:
			btn.pressed.connect(Callable(self, "_special_buttons").bind(btn))
	for container in dart_input_container.get_children():
		for ctn in container.get_children():
			if ctn.is_class("HBoxContainer"):
				for btn in ctn.get_children():
					btn.pressed.connect(Callable(self, "_multiplier_buttons").bind(btn))
	
	# Set-in proprety of players
	setting.score = 181
	player_01 = key[0]
	player_02 = key[1] 
	list_player = [player_01, player_02]
	GlobalData.player_list[key[0]].stat = player_01_container.statistic_container
	GlobalData.player_list[key[0]].history = player_01_container.history_container
	GlobalData.player_list[key[0]].target_score_label = player_01_container.score_label
	GlobalData.player_list[key[0]].name_container = player_01_container.name_container

	GlobalData.player_list[key[1]].stat = player_02_container.statistic_container
	GlobalData.player_list[key[1]].history = player_02_container.history_container
	GlobalData.player_list[key[1]].target_score_label = player_02_container.score_label
	GlobalData.player_list[key[1]].name_container = player_02_container.name_container
	
	_start_game()
	
	
func _process(delta):
	if Input.is_action_just_pressed("InGameMenu"):
			const in_game_menu_scene = preload("res://gamemode/scene/in_game_menu.tscn")
			var instance = in_game_menu_scene.instantiate()
			self.add_child(instance)

func _number_buttons(btn):
	var multiplier = 1
	var dart_label = null
	if dart_1_value_check == false:
		dart_label = dart_1_label
		dart_1_value_check = true
	elif dart_2_value_check == false:
		dart_label = dart_2_label
		dart_2_value_check = true
	elif dart_3_value_check == false:
		dart_label = dart_3_label
		dart_3_value_check = true
	if (dart_label != null):
		for i in range(2):
			var path = dart_label.get_parent().get_children()[0].get_children()[i]
			if path.button_pressed == true:
				multiplier = path.name.to_int()
		dart_label.text = str(int(btn.text) * multiplier)

func _special_buttons(btn):
	if btn.name == "Validate":
		_update_score()
	
	elif btn.name == "Delete":
		if dart_3_value_check == true:
			dart_3_label.text = ""
			dart_3_value_check = false
		elif dart_2_value_check == true:
			dart_2_label.text = ""
			dart_2_value_check = false
		elif dart_1_value_check == true:
			dart_1_label.text = ""
			dart_1_value_check = false	

	elif btn.name == "Redo":
		_redo_input()

func _multiplier_buttons(btn):
	var other_btn
	var dart_label
	for label in btn.get_parent().get_parent().get_children():
		if label.is_class("Label"):
			dart_label = label
	for others_btn in btn.get_parent().get_children():
		if others_btn.name != btn.name:
			other_btn = others_btn
	if other_btn.button_pressed == true:
		var default = str(int(dart_label.text) / other_btn.name.to_int())
		dart_label.text = str(int(default) * btn.name.to_int())
		other_btn.button_pressed = false
	elif btn.button_pressed == false:
		dart_label.text = str(int(dart_label.text) / btn.name.to_int())
	else:
		dart_label.text = str(int(dart_label.text) * btn.name.to_int())

func _start_game():
	for i in range(len(key)):
		#Reseting Player Proprety
		GlobalData.player_list[key[i]].target_score = setting.score
		GlobalData.player_list[key[i]].number_of_turn = 0
		GlobalData.player_list[key[i]].turn = false
		GlobalData.player_list[key[i]].average = 0
		GlobalData.player_list[key[i]].score_80 = 0
		GlobalData.player_list[key[i]].score_100 = 0
		GlobalData.player_list[key[i]].score_140 = 0
		GlobalData.player_list[key[i]].score_180 = 0
		
		#Resetting up the historic of throws
		for k in range(9):
			var temp = GlobalData.player_list[key[i]].history.get_children()[k].get_children()[0].get_children()
			temp[0].text = ""
			temp[1].text = ""
		GlobalData.player_list[key[i]].history.get_children()[0].get_children()[0].get_children()[1].text = str(setting.score)
		#Reset label of target score
		GlobalData.player_list[key[i]].target_score_label.text = str(setting.score)
		for k in range(0,3,2):
			GlobalData.player_list[key[i]].name_container.get_children()[k].get_children()[0].visible = false
		
	#Loading up the stats of players:
		for k in range(2,6):
			GlobalData.player_list[key[i]].stat.get_children()[k].get_children()[1].text = "0"
		GlobalData.player_list[key[i]].stat.get_children()[1].get_children()[1].text = str(GlobalData.player_list[key[i]].leg)
		GlobalData.player_list[key[i]].stat.get_children()[7].get_children()[1].text = "0.00"
		GlobalData.player_list[key[i]].stat.get_children()[8].get_children()[1].text = "%.2f" % GlobalData.player_list[key[i]].average_per_leg
	
	GlobalData.player_list[key[0]].turn = true
	GlobalData.player_list[key[0]].name_container.get_children()[0].get_children()[0].visible =  true
	GlobalData.player_list[key[0]].name_container.get_children()[2].get_children()[0].visible =  true
	
func _update_score():
	var player: Player
	#Pick which player to update
	if GlobalData.player_list[key[0]].turn == true:
		player = GlobalData.player_list[key[0]]
		GlobalData.player_list[key[0]].turn = false
		GlobalData.player_list[key[1]].turn = true
		for k in range(0,3,2):
			GlobalData.player_list[key[0]].name_container.get_children()[k].get_children()[0].visible =  false
			GlobalData.player_list[key[1]].name_container.get_children()[k].get_children()[0].visible = true
	else:
		player = GlobalData.player_list[key[1]]
		GlobalData.player_list[key[0]].turn = true
		GlobalData.player_list[key[1]].turn = false
		for k in range(0,3,2):
			GlobalData.player_list[key[0]].name_container.get_children()[k].get_children()[0].visible =  true
			GlobalData.player_list[key[1]].name_container.get_children()[k].get_children()[0].visible = false
	
	player.dart_1 = int(dart_1_label.text)
	player.dart_2 = int(dart_2_label.text)
	player.dart_3 = int(dart_3_label.text)
	player.total_throw = player.dart_1 + player.dart_2 + player.dart_3
	player.total_score = player.total_score + player.total_throw
	
	var new_score = player.target_score - player.total_throw
	
	if (new_score > 0): #Hit
		
		if (setting.double_out == true && new_score == 1):
			_bust(player)
		elif (setting.double_in == true && player.target_score == setting.score):
			if dart_1_label.get_parent().get_children()[0].get_children()[0].button_pressed == true:
				_new_score(player, new_score)
			else:
				_bust(player)
		else:
			_new_score(player, new_score)
		
	elif (new_score == 0): #Winning the game
	
		if (setting.double_out == false): #Double Out rule is not active
			number_of_leg += 1
			player.leg += 1
			player.number_of_turn += 1
			_update_stats_average(player)
			_start_game()
		else: # Double Out is active
			var dart_value_check = [dart_3_value_check, dart_2_value_check, dart_1_value_check]
			var dart_label = [dart_3_label, dart_2_label, dart_1_label]
			var double_out = false
			for i in range(3): #Checking last input is a double
				if dart_value_check[i] == true:
					if dart_label[i].get_parent().get_children()[0].get_children()[0].button_pressed == true:
						number_of_leg += 1
						player.leg += 1
						double_out = true
						player.number_of_turn += 1
						_update_stats_average(player)
						_start_game()
						break
			if (double_out == false):
				_bust(player)
		
	elif (new_score < 0): #Bust
		_bust(player)
	
	player.target_score_label.text = str(player.target_score)
	_reset_input()

func _update_stats_total(player: Player):
	if player.total_throw in range(80,99):
		player.score_80 += 1
		player.stat.get_children()[2].get_children()[1].text = str(player.score_80) 
	elif player.total_throw in range(100,139):
		player.score_100 += 1
		player.stat.get_children()[3].get_children()[1].text = str(player.score_100) 
	elif player.total_throw in range(140,179):
		player.score_140 += 1
		player.stat.get_children()[4].get_children()[1].text = str(player.score_140) 
	elif player.total_throw >= 180:
		player.score_180 += 1
		player.stat.get_children()[5].get_children()[1].text = str(player.score_180) 

func _update_stats_average(player: Player):

	player.average = float(player.total_score) / float(player.number_of_turn)
	player.stat.get_children()[7].get_children()[1].text =  "%.2f" % player.average
	player.average_per_leg = player.average / number_of_leg
	player.stat.get_children()[8].get_children()[1].text = "%.2f" % player.average_per_leg

func _new_score(player: Player, new_score):
	_update_stats_total(player)
	player.target_score = new_score

	var value_changed = false
	
	for i in range(9):
		var path_container = player.history.get_children()[i].get_children()[0].get_children()
		if path_container[1].text == "":
			path_container[0].text = str(player.total_throw)
			path_container[1].text = str(player.target_score)
			value_changed = true
			break
			
	if value_changed == false:
		for k in range(8):
			var path_container = player.history.get_children()[k].get_children()[0].get_children()
			var path_container_next = player.history.get_children()[k+1].get_children()[0].get_children()
			path_container[0].text = path_container_next[0].text
			path_container[1].text = path_container_next[1].text
		var path_container = player.history.get_children()[8].get_children()[0].get_children()
		path_container[0].text = str(player.total_throw)
		path_container[1].text = str(player.target_score)
		
	player.number_of_turn += 1
	_update_stats_average(player)
	
func _bust(player: Player):
	
	var value_changed = false
	
	for i in range(9):#adding score to each label till they're full
		var path_container = player.history.get_children()[i].get_children()[0].get_children()
		if path_container[1].text == "":
			path_container[0].text = "0"
			path_container[1].text = str(player.target_score)
			value_changed = true
			break
			
	if value_changed == false: #Looping throught the historic to update each on the next one while adding the newer score
		for k in range(8):
			var path_container = player.history.get_children()[k].get_children()[0].get_children()
			var path_container_next = player.history.get_children()[k+1].get_children()[0].get_children()
			path_container[0].text = path_container_next[0].text
			path_container[1].text = path_container_next[1].text
		var path_container = player.history.get_children()[8].get_children()[0].get_children()
		path_container[0].text = "0"
		path_container[1].text = str(player.target_score)

	player.number_of_turn += 1
	_update_stats_average(player)

func _redo_input():

	_reset_input()
	#Pick which player to redo
	if GlobalData.player_list[key[0]].number_of_turn > 0 || GlobalData.player_list[key[1]].number_of_turn > 0:
		var player: Player
		if GlobalData.player_list[key[0]].turn == true:
			player = GlobalData.player_list[key[1]]
			GlobalData.player_list[key[0]].turn = false
			GlobalData.player_list[key[1]].turn = true
			for k in range(0,3,2):
				GlobalData.player_list[key[0]].name_container.get_children()[k].get_children()[0].visible =  false
				GlobalData.player_list[key[1]].name_container.get_children()[k].get_children()[0].visible = true
		else:
			player = GlobalData.player_list[key[0]]
			GlobalData.player_list[key[0]].turn = true
			GlobalData.player_list[key[1]].turn = false
			for k in range(0,3,2):
				GlobalData.player_list[key[0]].name_container.get_children()[k].get_children()[0].visible =  true
				GlobalData.player_list[key[1]].name_container.get_children()[k].get_children()[0].visible = false

		if player.number_of_turn == 1:
			var path_container = player.history.get_children()[1].get_children()[0].get_children()
			player.total_throw = 0
			player.target_score = setting.score
			player.number_of_turn -= 1
			path_container[0].text = ""
			path_container[1].text = ""
			_back_stats(player)

		elif player.number_of_turn > 1: 
			var cant_redo = true
			for i in range(8,0,-1):
				var path_container = player.history.get_children()[i].get_children()[0].get_children()
				if path_container[1].text != "":
					player.total_throw = int(path_container[0].text)
					player.target_score += player.total_throw
					player.total_score -= player.total_throw 
					player.number_of_turn -= 1
					path_container = player.history.get_children()[i].get_children()[0].get_children()
					path_container[0].text = ""
					path_container[1].text = ""
					
					#Update Stats:
					_back_stats(player)
					cant_redo = false
					break
			if cant_redo == true:
				if GlobalData.player_list[key[0]].turn == true:
					GlobalData.player_list[key[0]].turn = false
					GlobalData.player_list[key[1]].turn = true
					for k in range(0,3,2):
						GlobalData.player_list[key[0]].name_container.get_children()[k].get_children()[0].visible =  false
						GlobalData.player_list[key[1]].name_container.get_children()[k].get_children()[0].visible = true
				else:
					GlobalData.player_list[key[0]].turn = true
					GlobalData.player_list[key[1]].turn = false
					for k in range(0,3,2):
						GlobalData.player_list[key[0]].name_container.get_children()[k].get_children()[0].visible =  true
						GlobalData.player_list[key[1]].name_container.get_children()[k].get_children()[0].visible = false
		
		player.target_score_label.text = str(player.target_score)
		
func _back_stats(player: Player):
	if player.number_of_turn == 0:
		player.average = 0.00
	else:
		player.average = float(player.total_score) / float(player.number_of_turn)
	player.stat.get_children()[7].get_children()[1].text =  "%.2f" % player.average 
	player.average_per_leg = player.average / number_of_leg
	player.stat.get_children()[8].get_children()[1].text = "%.2f" % player.average_per_leg
		
	if player.total_throw in range(80,99):
		player.score_80 -= 1
		player.stat.get_children()[2].get_children()[1].text = str(player.score_80) 
	elif player.total_throw in range(100,139):
		player.score_100 -= 1
		player.stat.get_children()[3].get_children()[1].text = str(player.score_100) 
	elif player.total_throw in range(140,179):
		player.score_140 -= 1
		player.stat.get_children()[4].get_children()[1].text = str(player.score_140) 
	elif player.total_throw >= 180:
		player.score_180 -= 1
		player.stat.get_children()[5].get_children()[1].text = str(player.score_180) 
func _reset_input():
	dart_1_label.text = ""
	dart_1_value_check = false
	dart_2_label.text = ""
	dart_2_value_check = false
	dart_3_label.text = ""
	dart_3_value_check = false
	
	#Reset multiplier button state
	for container in dart_input_container.get_children():
			for ctn in container.get_children():
				if ctn.is_class("HBoxContainer"):
					for btn in ctn.get_children():
						btn.button_pressed = false


