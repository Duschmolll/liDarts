extends Control

@export var selectedGrid: GridContainer
@export var playerList: GridContainer

@export var validateButton: Button

@onready var setting = GlobalData.setting.x01
var playerIndex: Array[int]

func createPlayerList():
	const PLAYER_LIST = preload("res://statistic/PlayerListStat.tscn")
	var gridChildren = playerList.get_children()
	if len(gridChildren) > 0:
		for i in range(0, len(gridChildren)):
			playerList.remove_child(gridChildren[i])
	if len(GlobalData.playerList) > 0:
		for elem in GlobalData.playerList:
			var instance = PLAYER_LIST.instantiate()
			instance.setup(elem, self)
			playerList.add_child(instance)



func playerPressed(player: Player):
	if player.index not in playerIndex:
		playerIndex.append(player.index)
		print(playerIndex)
		var playerNode = load("res://gameSelection/playerSelection/PlayerButton.tscn")
		var instance = playerNode.instantiate()
		instance.setup(player, playerIndex)
		selectedGrid.add_child(instance)
		
	
func _ready() -> void:
	createPlayerList()

func _process(delta: float) -> void:
	if len(playerIndex) > 1:
		validateButton.disabled = false
	else:
		validateButton.disabled = true

func launchGame() -> void:
	for elem in playerIndex:
		setting.selectedPlayerIndex.append(elem)
	get_tree().change_scene_to_file(GlobalData.gameSelected)


func returnGameSelection() -> void:
	get_tree().change_scene_to_file("res://gameSelection/GameSelection.tscn")
