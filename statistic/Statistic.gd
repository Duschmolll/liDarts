extends Control

@export var player_list_grid: GridContainer
@export var player_stats_hbox: HBoxContainer
var local_player_selected = []


func _ready():
	create_player_list()


func create_player_list():
	const PLAYER_LIST = preload("res://statistic/PlayerListStat.tscn")
	var grid_children = player_list_grid.get_children()
	if len(grid_children) > 0:
		for i in range(0, len(grid_children)):
			player_list_grid.remove_child(grid_children[i])
	if len(GlobalData.playerList) > 0:
		for elem in GlobalData.playerList:
			var instance = PLAYER_LIST.instantiate()
			instance.setup(elem, self)
			player_list_grid.add_child(instance)



func playerPressed(player: Player):
	if len(local_player_selected) < 2:
		for i in range(len(local_player_selected)):
			if player == local_player_selected[i]:
				return
		const PLAYER_STAT = preload("res://statistic/PlayerListContainer.tscn")
		var instance = PLAYER_STAT.instantiate()
		instance.loadPlayer(player)
		local_player_selected.append(player)
		player_stats_hbox.add_child(instance)
		check_opponent()


func check_opponent():
	if len(local_player_selected) == 2:
		for i in range(2):
			var child = player_stats_hbox.get_children()[i]
			child.opponent_game.text = str(local_player_selected[i].name)
			child.opponent_winrate.text = str(local_player_selected[i].name)
			child.opponent_selected.visible = true
			child.opponent_unselected.visible = false
		player_stats_hbox.get_children()[0].opponent.text = str(local_player_selected[1].name)
		player_stats_hbox.get_children()[1].opponent.text = str(local_player_selected[0].name)
	else:
		for i in range(player_stats_hbox.get_child_count()):
			var child = player_stats_hbox.get_children()[i]
			child.opponent_selected.visible = false
			child.opponent_unselected.visible = true


func _on_button_pressed():
	get_tree().change_scene_to_file("res://mainMenu/MainMenu.tscn")
