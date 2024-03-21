extends Control

@export var player_list_grid: GridContainer
@export var player_stats_hbox: HBoxContainer
var local_player_selected = []
func _ready():
	create_player_list()


func create_player_list():
	const PLAYER_LIST = preload("res://statistic/player_list_stats.tscn")
	var grid_children = player_list_grid.get_children()
	if len(grid_children) > 0:
		for i in range(0, len(grid_children)):
			player_list_grid.remove_child(grid_children[i])
	if len(GlobalData.player_list.keys()) > 0:
		var i = 0
		for key in GlobalData.player_list.keys():
			var instance = PLAYER_LIST.instantiate()
			player_list_grid.add_child(instance)
			player_list_grid.get_children()[i].get_children()[0].get_children()[0].get_children()[1].text = GlobalData.player_list[key].name
			player_list_grid.get_children()[i].get_children()[0].get_children()[0].get_children()[0].get_children()[0].set_texture(load(GlobalData.player_list[key].flag))
			i += 1

func get_statistic(player):
	if len(local_player_selected) < 2:
		for i in range(len(local_player_selected)):
			if player == local_player_selected[i]:
				return
		const PLAYER_STAT = preload("res://statistic/player_stats_container.tscn")
		var instance = PLAYER_STAT.instantiate()
		instance.player_label.text = str(GlobalData.player_list[player].name)
		instance.player_flag.set_texture(load(GlobalData.player_list[player].flag))
		instance.game_played.text = str(GlobalData.player_list[player].name)
		instance.leg_played.text = str(GlobalData.player_list[player].all_time_leg)
		instance.game_won.text = str(GlobalData.player_list[player].name)
		instance.break_leg.text = str(GlobalData.player_list[player].name)
		instance.throw.text = str(GlobalData.player_list[player].all_time_throw)
		instance.dart.text = str(GlobalData.player_list[player].all_time_dart)
		instance.play_time.text = str(GlobalData.player_list[player].name)
		instance.average.text = str(GlobalData.player_list[player].all_time_average_per_throw)
		instance.average_per_leg.text = str(GlobalData.player_list[player].all_time_average_per_leg)
		local_player_selected.append(player)
		player_stats_hbox.add_child(instance)
		check_opponent()


func check_opponent():
	if len(local_player_selected) == 2:
		for i in range(2):
			var child = player_stats_hbox.get_children()[i]
			child.opponent_game.text = str(GlobalData.player_list[local_player_selected[i]].name)
			child.opponent_winrate.text = str(GlobalData.player_list[local_player_selected[i]].name)
			child.opponent_selected.visible = true
			child.opponent_unselected.visible = false
		player_stats_hbox.get_children()[0].opponent.text = str(GlobalData.player_list[local_player_selected[1]].name)
		player_stats_hbox.get_children()[1].opponent.text = str(GlobalData.player_list[local_player_selected[0]].name)
	else:
		for i in range(player_stats_hbox.get_child_count()):
			var child = player_stats_hbox.get_children()[i]
			child.opponent_selected.visible = false
			child.opponent_unselected.visible = true
