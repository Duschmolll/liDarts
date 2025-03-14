extends Control

@export var playerGrid: GridContainer

@onready var playerListNode = preload("res://player/PlayerList.tscn")

func _ready():
	createPlayerList()

func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://mainMenu/MainMenu.tscn")

func _on_new_player_pressed():
	const addPlayerScene = preload("res://player/AddPlayer.tscn")
	var instance = addPlayerScene.instantiate()
	instance.parent = self
	self.add_child(instance)

func createPlayerList():
	var gridChildren = playerGrid.get_children()
	
	if len(gridChildren) > 0:
		for i in range(0, len(gridChildren)):
			playerGrid.remove_child(gridChildren[i])
	
	if len(GlobalData.playerList) > 0:
		for elem in GlobalData.playerList:
			var instance = playerListNode.instantiate()
			instance.setup(elem)
			playerGrid.add_child(instance)

func player_list_updated():
	createPlayerList()
