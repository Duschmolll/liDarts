extends Control

# Containers:
@onready var historic_player_01_container = $MarginContainer/VBoxContainer/HBoxContainer/Player1/PanelContainer/MarginContainer/FlowContainer/Historic
@onready var historic_player_02_container = $MarginContainer/VBoxContainer/HBoxContainer/Player2/PanelContainer/MarginContainer/FlowContainer/Historic
@onready var stat_player_01_container = $MarginContainer/VBoxContainer/HBoxContainer/Player1/PanelContainer/MarginContainer/FlowContainer/Stats
@onready var stat_player_02_container = $MarginContainer/VBoxContainer/HBoxContainer/Player2/PanelContainer/MarginContainer/FlowContainer/Stats
@onready var button_container = $MarginContainer/VBoxContainer/MarginContainer/PanelContainer/Input/GridContainer
@onready var dart_input_container = $MarginContainer/VBoxContainer/MarginContainer/PanelContainer/Input/DartScore

# Label:
@onready var dart_1_label = $MarginContainer/VBoxContainer/MarginContainer/PanelContainer/Input/DartScore/Dart1Score/Dart1
@onready var dart_2_label = $MarginContainer/VBoxContainer/MarginContainer/PanelContainer/Input/DartScore/Dart2Score/Dart2
@onready var dart_3_label = $MarginContainer/VBoxContainer/MarginContainer/PanelContainer/Input/DartScore/Dart3Score/Dart3
@onready var player_01_score_label = $MarginContainer/VBoxContainer/HBoxContainer/Player1/Score/Player1Score
@onready var player_02_score_label = $MarginContainer/VBoxContainer/HBoxContainer/Player2/Score/Player2Score

# Variables: 
var dart_1_value_check: bool = false
var dart_2_value_check: bool = false
var dart_3_value_check: bool = false
var number_of_turn = 1
var number_of_leg = 0
var total_of_turn = 1
var player_turn = 0
var player_01_total_score = 0
var player_02_total_score = 0
var player_01_total_of_leg = 0
var player_02_total_of_leg = 0
var player_01_leg = 0
var player_02_leg = 0
var player_01_average = 0
var player_02_average = 0
var player_01_average_leg = 0
var player_02_average_leg = 0

func _start_game():
	
	player_01_score_label.text = "181"
	player_02_score_label.text = "181"
	for i in range(9):
			var temp = historic_player_01_container.get_children()[i].get_children()[0].get_children()
			var temp2 = historic_player_02_container.get_children()[i].get_children()[0].get_children()
			temp[0].text = ""
			temp[1].text = ""
			temp2[0].text = ""
			temp2[1].text = ""
	historic_player_01_container.get_children()[0].get_children()[0].get_children()[1].text = player_01_score_label.text
	historic_player_02_container.get_children()[0].get_children()[0].get_children()[1].text = player_02_score_label.text
	for i in range(2,6):
		stat_player_01_container.get_children()[i].get_children()[1].text = "0"
		stat_player_02_container.get_children()[i].get_children()[1].text = "0"
	stat_player_01_container.get_children()[1].get_children()[1].text = str(player_01_leg)
	stat_player_02_container.get_children()[1].get_children()[1].text = str(player_02_leg)
func _ready():
	
	_start_game()
	
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
	
func _number_buttons(btn):
	if dart_1_value_check == false:
		dart_1_label.text = btn.text
		dart_1_value_check = true
	elif dart_2_value_check == false:
		dart_2_label.text = btn.text
		dart_2_value_check = true
	elif dart_3_value_check == false:
		dart_3_label.text = btn.text 
		dart_3_value_check = true

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

func _update_stats_total(total_dart, path):
	if total_dart in range(80,99):
		path.get_children()[2].get_children()[1].text = str(int(path.get_children()[2].get_children()[1].text) + 1) 
	elif total_dart in range(100,139):
		path.get_children()[3].get_children()[1].text = str(int(path.get_children()[3].get_children()[1].text) + 1) 
	elif total_dart in range(140,179):
		path.get_children()[4].get_children()[1].text = str(int(path.get_children()[4].get_children()[1].text) + 1) 
	elif total_dart >= 180:
		path.get_children()[5].get_children()[1].text = str(int(path.get_children()[5].get_children()[1].text) + 1) 

func _update_stats_average(path, total_dart, player_total_score):
	
	var averages = (player_total_score + total_dart) / number_of_turn
	path.get_children()[7].get_children()[1].text = str(averages)
	if player_turn == 0:
		player_01_total_score += total_dart
	else:
		player_02_total_score += total_dart

func _update_score():
	var path = Node
	var score = Node
	var stats_path = Node
	var player_total = 0
	#Switch player turn
	if player_turn == 0:
		path = historic_player_01_container
		score = player_01_score_label
		stats_path = stat_player_01_container
		player_total = player_01_total_score
	else:
		path = historic_player_02_container
		score = player_02_score_label
		stats_path = stat_player_02_container
		player_total = player_02_total_score

	
	var total_dart = int(dart_1_label.text) + int(dart_2_label.text) + int(dart_3_label.text)
	var new_score = int(score.text) - total_dart
	_update_stats_average(stats_path, total_dart, player_total)
	if (new_score > 0):
		
		_update_stats_total(total_dart, stats_path)
		score.text = str(new_score)
		
		if number_of_turn < 9: #adding score to each label till they're full
			var temp = path.get_children()[number_of_turn].get_children()[0].get_children()
			temp[0].text = str(total_dart)
			temp[1].text = score.text

		else: #Looping throught the historic to update each on the next one while adding the newer score
			for i in range(8):
				var temp = path.get_children()[i].get_children()[0].get_children()
				var temp2 = path.get_children()[i+1].get_children()[0].get_children()
				temp[0].text = temp2[0].text
				temp[1].text = temp2[1].text
			var temp = path.get_children()[8].get_children()[0].get_children()
			temp[0].text = str(total_dart)
			temp[1].text = score.text

	elif (new_score == 0):
		number_of_leg += 1
		if player_turn == 0:
			player_01_leg += 1
		else:
			player_02_leg += 1
		_start_game()
	elif (new_score < 0):
		if number_of_turn < 9: #adding score to each label till they're full
			var temp = path.get_children()[number_of_turn].get_children()[0].get_children()
			temp[0].text = "0"
			temp[1].text = score.text

		else: #Looping throught the historic to update each on the next one while adding the newer score
			for i in range(8):
				var temp = path.get_children()[i].get_children()[0].get_children()
				var temp2 = path.get_children()[i+1].get_children()[0].get_children()
				temp[0].text = temp2[0].text
				temp[1].text = temp2[1].text
			var temp = path.get_children()[8].get_children()[0].get_children()
			temp[0].text = "0"
			temp[1].text = score.text
	if player_turn == 1:
		number_of_turn += 1
	_reset_input()
		

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
	
func _special_buttons(btn):
	if btn.name == "Validate":
		_update_score()
		if player_turn == 1:
			player_turn = 0
		else:
			player_turn = 1
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
		print("Redo")	
