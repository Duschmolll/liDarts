extends Control

# Containers:
@onready var button_container = $MarginContainer/VBoxContainer/MarginContainer/PanelContainer/Input/GridContainer
@onready var dart_input_container = $MarginContainer/VBoxContainer/MarginContainer/PanelContainer/Input/DartScore

# Label:
@onready var dart_1_label = $MarginContainer/VBoxContainer/MarginContainer/PanelContainer/Input/DartScore/Dart1Score/Dart1
@onready var dart_2_label = $MarginContainer/VBoxContainer/MarginContainer/PanelContainer/Input/DartScore/Dart2Score/Dart2
@onready var dart_3_label = $MarginContainer/VBoxContainer/MarginContainer/PanelContainer/Input/DartScore/Dart3Score/Dart3

# Variables: 
var dart_1_value_check: bool = false
var dart_2_value_check: bool = false
var dart_3_value_check: bool = false
var number_of_leg = 1
var total_of_turn = 1

var setting = X_01_Settings.new()
var player_01 = Player.new()
var player_02 = Player.new()
var list_player: Array[Player] = [player_01, player_02]


func _ready():
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
	
	player_01.name = "Andrew"
	player_01.stat = $MarginContainer/VBoxContainer/HBoxContainer/Player1/PanelContainer/MarginContainer/FlowContainer/Stats
	player_01.history = $MarginContainer/VBoxContainer/HBoxContainer/Player1/PanelContainer/MarginContainer/FlowContainer/Historic
	player_01.target_score_label = $MarginContainer/VBoxContainer/HBoxContainer/Player1/Score/Player1Score
	player_01.name_label = $MarginContainer/VBoxContainer/HBoxContainer/Player1/Name/CenterContainer/Player/Name
	
	player_02.name = "John"
	player_02.stat = $MarginContainer/VBoxContainer/HBoxContainer/Player2/PanelContainer/MarginContainer/FlowContainer/Stats
	player_02.history = $MarginContainer/VBoxContainer/HBoxContainer/Player2/PanelContainer/MarginContainer/FlowContainer/Historic
	player_02.target_score_label = $MarginContainer/VBoxContainer/HBoxContainer/Player2/Score/Player2Score
	player_02.name_label = $MarginContainer/VBoxContainer/HBoxContainer/Player2/Name/CenterContainer/Player/Name
	 
	_start_game()
	
	

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
	for i in range(len(list_player)):
		#Reseting Player Proprety
		list_player[i].target_score = setting.score
		list_player[i].number_of_turn = 0
		list_player[i].turn = false
		list_player[i].average = 0
		list_player[i].score_80 = 0
		list_player[i].score_100 = 0
		list_player[i].score_140 = 0
		list_player[i].score_180 = 0
		list_player[i].name_label.text = list_player[i].name
		
		#Resetting up the historic of throws
		for k in range(9):
			var temp = list_player[i].history.get_children()[k].get_children()[0].get_children()
			temp[0].text = ""
			temp[1].text = ""
		list_player[i].history.get_children()[0].get_children()[0].get_children()[1].text = str(setting.score)
		#Reset label of target score
		list_player[i].target_score_label.text = str(setting.score)
		for k in range(0,3,2):
			list_player[i].name_label.get_parent().get_children()[k].get_children()[0].visible = false
		
	#Loading up the stats of players:
		for k in range(2,6):
			list_player[i].stat.get_children()[k].get_children()[1].text = "0"
		list_player[i].stat.get_children()[1].get_children()[1].text = str(list_player[i].leg)
		list_player[i].stat.get_children()[7].get_children()[1].text = "0.00"
		list_player[i].stat.get_children()[8].get_children()[1].text = "%.2f" % list_player[i].average_per_leg
	
	player_01.turn = true
	player_01.name_label.get_parent().get_children()[0].get_children()[0].visible =  true
	player_01.name_label.get_parent().get_children()[2].get_children()[0].visible =  true
	
func _update_score():
	var player: Player
	#Pick which player to update
	if player_01.turn == true:
		player = player_01
		player_01.turn = false
		player_02.turn = true
		for k in range(0,3,2):
			player_01.name_label.get_parent().get_children()[k].get_children()[0].visible =  false
			player_02.name_label.get_parent().get_children()[k].get_children()[0].visible = true
	else:
		player = player_02
		player_01.turn = true
		player_02.turn = false
		for k in range(0,3,2):
			player_01.name_label.get_parent().get_children()[k].get_children()[0].visible =  true
			player_02.name_label.get_parent().get_children()[k].get_children()[0].visible = false
	
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
	if player_01.number_of_turn > 0 || player_02.number_of_turn > 0:
		var player: Player
		if player_01.turn == true:
			player = player_02
			player_01.turn = false
			player_02.turn = true
			for k in range(0,3,2):
				player_01.name_label.get_parent().get_children()[k].get_children()[0].visible =  false
				player_02.name_label.get_parent().get_children()[k].get_children()[0].visible = true
		else:
			player = player_01
			player_01.turn = true
			player_02.turn = false
			for k in range(0,3,2):
				player_01.name_label.get_parent().get_children()[k].get_children()[0].visible =  true
				player_02.name_label.get_parent().get_children()[k].get_children()[0].visible = false

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
				if player_01.turn == true:
					player_01.turn = false
					player_02.turn = true
					for k in range(0,3,2):
						player_01.name_label.get_parent().get_children()[k].get_children()[0].visible =  false
						player_02.name_label.get_parent().get_children()[k].get_children()[0].visible = true
				else:
					player_01.turn = true
					player_02.turn = false
					for k in range(0,3,2):
						player_01.name_label.get_parent().get_children()[k].get_children()[0].visible =  true
						player_02.name_label.get_parent().get_children()[k].get_children()[0].visible = false
		
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


