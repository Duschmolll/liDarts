extends Control

@onready var grid: GridContainer = self.get_children()[0]

var player_list = ["Player1", "Player2", "Player3"]
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(len(player_list)):
		var instance = PLAYER_LIST.instantiate()
		grid.add_child(instance)
		grid.get_children()[i].get_children()[0].get_children()[0].get_children()[1].text = player_list[i]
	print(self.get_children()[0])

const PLAYER_LIST = preload("res://player_list.tscn")

