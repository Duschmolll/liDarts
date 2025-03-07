extends Control

@export var selectedGrid: GridContainer
@export var playerList: GridContainer

func create_player_list():
	const PLAYER_LIST = preload("res://statistic/player_list_stats.tscn")
	var grid_children = playerList.get_children()
	if len(grid_children) > 0:
		for i in range(0, len(grid_children)):
			playerList.remove_child(grid_children[i])
	if len(GlobalData.playerList) > 0:
		var i = 0
		for elem in GlobalData.playerList:
			var instance = PLAYER_LIST.instantiate()
			instance.nameLabel.text = elem.name
			instance.flagTextureRect.set_texture(load(elem.flag))
			instance.player = elem
			instance.parentNode = self
			playerList.add_child(instance)
			i += 1


func playerPressed(player: Player):
	print("PlayerPressed")
	#var playerNode = load("res://gameSelection/playerSelection/player.tscn")
	pass
	
func _ready() -> void:
	create_player_list()
