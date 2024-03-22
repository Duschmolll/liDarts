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

var player_01: String 
var player_02: String 
var list_player: Array[String]
var key: Array

func _ready():
	
	key = GlobalData.player_selected.keys()
	# Set-in functions for all buttons:
	for btn in button_container.get_children():
		if btn.text.is_valid_int():
			btn.pressed.connect(Callable(self, "number_buttons").bind(btn))
		else:
			btn.pressed.connect(Callable(self, "special_buttons").bind(btn))
	for container in dart_input_container.get_children():
		for ctn in container.get_children():
			if ctn.is_class("HBoxContainer"):
				for btn in ctn.get_children():
					btn.pressed.connect(Callable(self, "multiplier_buttons").bind(btn))
	
	# Set-in proprety of players
	GlobalData.player_list[key[0]].container = player_01_container
	GlobalData.player_list[key[1]].container = player_02_container

	start_game()


func _process(_delta):
	if Input.is_action_just_pressed("InGameMenu"):
			const in_game_menu_scene = preload("res://gamemode/scene/in_game_menu.tscn")
			var instance = in_game_menu_scene.instantiate()
			self.add_child(instance)


func number_buttons(btn):
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


func special_buttons(btn):
	if btn.name == "Validate":
		update_score()
		
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
		redo_input()


func multiplier_buttons(btn):
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


func start_game():
	for i in range(len(key)):
		#Reseting Player Proprety
		GlobalData.player_list[key[i]].target_score = GlobalData.setting['x01'].score
		GlobalData.player_list[key[i]].number_of_turn = 0
		GlobalData.player_list[key[i]].turn = false
		GlobalData.player_list[key[i]].average = 0
		GlobalData.player_list[key[i]].score_80 = 0
		GlobalData.player_list[key[i]].score_100 = 0
		GlobalData.player_list[key[i]].score_140 = 0
		GlobalData.player_list[key[i]].score_180 = 0
		GlobalData.player_list[key[i]].container.turn_arrow_left.visible = false
		GlobalData.player_list[key[i]].container.turn_arrow_right.visible = false
		#Resetting up the historic of throws
		for k in range(9):
			GlobalData.player_list[key[i]].container.history_throw[k].text = ""
			GlobalData.player_list[key[i]].container.history_score[k].text = ""
		GlobalData.player_list[key[i]].container.history_score[0].text = str(GlobalData.setting['x01'].score)
		
		#Reset label of target score
		GlobalData.player_list[key[i]].container.score_label.text = str(GlobalData.setting['x01'].score)


	#Loading up the stats of players:
		for k in range(4):
			GlobalData.player_list[key[0]].container.statistic_total[i].text = "0"
			
		GlobalData.player_list[key[i]].container.stat_leg.text = str(GlobalData.player_list[key[i]].leg)
		GlobalData.player_list[key[i]].container.stat_average.text = "0.00"
		GlobalData.player_list[key[i]].container.stat_average_leg.text = "%.2f" % GlobalData.player_list[key[i]].average_per_leg
	
	GlobalData.player_list[key[0]].turn = true
	GlobalData.player_list[key[0]].container.turn_arrow_left.visible = true
	GlobalData.player_list[key[0]].container.turn_arrow_right.visible = true


func update_score():
	var player: Player
	#Pick which player to update
	if GlobalData.player_list[key[0]].turn == true:
		player = GlobalData.player_list[key[0]]
		GlobalData.player_list[key[0]].turn = false
		GlobalData.player_list[key[1]].turn = true
		GlobalData.player_list[key[0]].container.turn_arrow_left.visible =  false
		GlobalData.player_list[key[0]].container.turn_arrow_right.visible = false
		GlobalData.player_list[key[1]].container.turn_arrow_left.visible = true
		GlobalData.player_list[key[1]].container.turn_arrow_right.visible = true
	else:
		player = GlobalData.player_list[key[1]]
		GlobalData.player_list[key[0]].turn = true
		GlobalData.player_list[key[1]].turn = false
		GlobalData.player_list[key[0]].container.turn_arrow_left.visible =  true
		GlobalData.player_list[key[0]].container.turn_arrow_right.visible = true
		GlobalData.player_list[key[1]].container.turn_arrow_left.visible = false
		GlobalData.player_list[key[1]].container.turn_arrow_right.visible = false
	
	player.dart_1 = int(dart_1_label.text)
	player.dart_2 = int(dart_2_label.text)
	player.dart_3 = int(dart_3_label.text)
	player.total_throw = player.dart_1 + player.dart_2 + player.dart_3
	player.total_score = player.total_score + player.total_throw
	
	var new_score = player.target_score - player.total_throw
	
	if (new_score > 0): #Hit
		
		if (GlobalData.setting['x01'].double_out == true && new_score == 1):
			bust(player)
		elif (GlobalData.setting['x01'].double_in == true && player.target_score == GlobalData.setting['x01'].score):
			if dart_1_label.get_parent().get_children()[0].get_children()[0].button_pressed == true:
				new_score(player, new_score)
			else:
				bust(player)
		else:
			new_score(player, new_score)
		
	elif (new_score == 0): #Winning the game
	
		if (GlobalData.setting['x01'].double_out == false): #Double Out rule is not active
			number_of_leg += 1
			player.leg += 1
			player.number_of_turn += 1
			update_stats_average(player)
			update_stat_global(player)
			start_game()
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
						update_stats_average(player)
						update_stat_global(player)
						start_game()
						break
			if (double_out == false):
				bust(player)
		
	elif (new_score < 0): #Bust
		bust(player)
	
	player.container.score_label.text = str(player.target_score)
	reset_input()


func update_stats_total(player: Player):
	if player.total_throw in range(80,99):
		player.score_80 += 1
		player.container.stat_80.text = str(player.score_80) 
	elif player.total_throw in range(100,139):
		player.score_100 += 1
		player.container.stat_100.text = str(player.score_100) 
	elif player.total_throw in range(140,179):
		player.score_140 += 1
		player.container.stat_140.text = str(player.score_140) 
	elif player.total_throw >= 180:
		player.score_180 += 1
		player.container.stat_180.text = str(player.score_180) 


func update_stats_average(player: Player):
	player.average = player.average + (player.total_throw - player.average) / float(player.number_of_turn)
	player.container.stat_average.text =  "%.2f" % player.average
	player.average_per_leg = player.average_per_leg + (player.average - player.average_per_leg) / number_of_leg
	player.container.stat_average_leg.text = "%.2f" % player.average_per_leg


func new_score(player: Player, new_score):
	update_stats_total(player)
	player.target_score = new_score

	var value_changed = false
	
	for i in range(9):#adding score to each label till they're full
		if player.container.history_score[i].text == "":
			player.container.history_throw[i].text = str(player.total_throw)
			player.container.history_score[i].text = str(player.target_score)
			value_changed = true
			break
			
	if value_changed == false:#Looping throught the historic to update each on the next one while adding the newer score
		for k in range(8):
			player.container.history_throw[k].text = player.container.history_throw[k+1].text
			player.container.history_score[k].text = player.container.history_score[k+1].text
		player.container.history_throw[8].text = str(player.total_throw)
		player.container.history_score[8].text = str(player.target_score)
		
	player.number_of_turn += 1
	if GlobalData.setting["x01"].show_check_out:
		check_out(player)
	update_stats_average(player)


func bust(player: Player):
	
	var value_changed = false
	
	for i in range(9):#adding score to each label till they're full
		if player.container.history_score[i].text == "":
			player.container.history_throw[i].text = "0"
			player.container.history_score[i].text = str(player.target_score)
			value_changed = true
			break
			
	if value_changed == false: #Looping throught the historic to update each on the next one while adding the newer score
		for k in range(8):
			player.container.history_throw[k].text = player.container.history_throw[k+1].text
			player.container.history_score[k].text = player.container.history_score[k+1].text
		player.container.history_throw[8].text = "0"
		player.container.history_score[8].text = str(player.target_score)

	player.number_of_turn += 1
	update_stats_average(player)


func redo_input():
	reset_input()
	#Pick which player to redo
	if GlobalData.player_list[key[0]].number_of_turn > 0 || GlobalData.player_list[key[1]].number_of_turn > 0:
		var player: Player
		if GlobalData.player_list[key[0]].turn == true:
			player = GlobalData.player_list[key[1]]
			GlobalData.player_list[key[0]].turn = false
			GlobalData.player_list[key[1]].turn = true
			GlobalData.player_list[key[0]].container.turn_arrow_left.visible =  false
			GlobalData.player_list[key[0]].container.turn_arrow_right.visible = false
			GlobalData.player_list[key[1]].container.turn_arrow_left.visible = true
			GlobalData.player_list[key[1]].container.turn_arrow_right.visible = true
		else:
			player = GlobalData.player_list[key[0]]
			GlobalData.player_list[key[0]].turn = true
			GlobalData.player_list[key[1]].turn = false
			GlobalData.player_list[key[0]].container.turn_arrow_left.visible =  true
			GlobalData.player_list[key[0]].container.turn_arrow_right.visible = true
			GlobalData.player_list[key[1]].container.turn_arrow_left.visible = false
			GlobalData.player_list[key[1]].container.turn_arrow_right.visible = false

		if player.number_of_turn == 1:
			player.total_throw = 0
			player.target_score = GlobalData.setting['x01'].score
			player.number_of_turn -= 1
			player.container.history_score[1].text = ""
			player.container.history_throw[1].text = ""
			back_stats(player)

		elif player.number_of_turn > 1: 
			var cant_redo = true
			for i in range(8,0,-1):
				if player.container.history_score[i].text != "":
					player.total_throw = int(player.container.history_throw[i].text)
					player.target_score += player.total_throw
					player.total_score -= player.total_throw 
					player.number_of_turn -= 1
					player.container.history_score[i].text = ""
					player.container.history_throw[i].text = ""
					
					#Update Stats:
					back_stats(player)
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
		
		player.container.score_label.text = str(player.target_score)


func back_stats(player: Player):
	if player.number_of_turn == 0:
		player.average = 0.00
	else:
		player.average = player.average - (player.total_throw - player.average) / float(player.number_of_turn)
	player.container.stat_average.text =  "%.2f" % player.average 
	
	player.average_per_leg = player.average_per_leg - (player.average_per_leg - player.average ) / number_of_leg
	player.container.stat_average_leg.text = "%.2f" % player.average_per_leg
	
	if player.total_throw in range(80,99):
		player.score_80 -= 1
		player.container.stat_80.text = str(player.score_80) 
	elif player.total_throw in range(100,139):
		player.score_100 -= 1
		player.container.stat_100.text = str(player.score_100) 
	elif player.total_throw in range(140,179):
		player.score_140 -= 1
		player.container.stat_140.text = str(player.score_140) 
	elif player.total_throw >= 180:
		player.score_180 -= 1
		player.container.stat_180.text = str(player.score_180) 


func reset_input():
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


func update_stat_global(player: Player):
	for i in range(len(key)):
		
		GlobalData.player_list[key[i]].all_time_throw += GlobalData.player_list[key[i]].number_of_turn
		GlobalData.player_list[key[i]].all_time_dart += GlobalData.player_list[key[i]].number_of_turn / 3
		GlobalData.player_list[key[i]].all_time_total_score += GlobalData.player_list[key[i]].total_score
		GlobalData.player_list[key[i]].all_time_leg += 1
		player.all_time_leg_win += 1
		
		GlobalData.player_list[key[i]].all_time_average_per_leg = GlobalData.player_list[key[i]].all_time_average_per_leg + (GlobalData.player_list[key[i]].average_per_leg - GlobalData.player_list[key[i]].all_time_average_per_leg) / GlobalData.player_list[key[i]].all_time_leg
		GlobalData.player_list[key[i]].all_time_average_per_throw = GlobalData.player_list[key[i]].all_time_average_per_throw + (GlobalData.player_list[key[i]].average - GlobalData.player_list[key[i]].all_time_average_per_throw) / GlobalData.player_list[key[i]].all_time_leg
		
		GlobalData.player_list[key[i]].all_time_score_80 += GlobalData.player_list[key[i]].score_80
		GlobalData.player_list[key[i]].all_time_score_100 += GlobalData.player_list[key[i]].score_100
		GlobalData.player_list[key[i]].all_time_score_140 += GlobalData.player_list[key[i]].score_140
		GlobalData.player_list[key[i]].all_time_score_180 += GlobalData.player_list[key[i]].score_180
	
	GlobalData.save_data("user://data/data.json")


func check_out(player: Player):
	var check_out_array = check_out_calculate(player.target_score)
	var check_out_string:String
	
	if check_out_array[0] == 0:
		player.check_out_label.text = ""
	else:
		for i in check_out_array:
			if i == 0:
				check_out_string += ""
			elif i % 3 == 0:
				check_out_string += "T" + str(i / 3) + " - "
			elif i % 2 == 0:
				check_out_string += "D" + str(i / 2) + " - "
			else:
				check_out_string += str(i) + " - "
		
		player.check_out_label.text = check_out_string.left(check_out_string.length() - 3)


func check_out_calculate(score: int):
	var dart
	var dart_value = [60,57,54,51,50,48,45,42,40,39,38,36,34,33,32,30,28,26,25,24,22,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1]
	
	for i in dart_value:
		dart = i
		if dart == score and not GlobalData.setting['x01'].double_out:
			return([i,0,0])
		elif dart == score and i % 2 == 0:
			return([i,0,0])
		else:
			for k in dart_value:
				dart += k
				if dart == score and not GlobalData.setting['x01'].double_out:
					return([i,k,0])
				elif dart == score and k % 2 == 0:
					return([i,k,0])
				else:
					for x in dart_value:
						dart += x
						if dart == score and not GlobalData.setting['x01'].double_out:
							return([i,k,x])
						elif dart == score and x % 2 == 0:
							return([i,k,x])
						dart -= x
				dart -= k
		dart -= i
	return ([0,0,0])






