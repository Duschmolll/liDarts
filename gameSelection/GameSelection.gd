extends Control

@export var gameMode: Node

func validate() -> void:
	gameMode.launch()
	
func returnToMenu() -> void:
	get_tree().change_scene_to_file("res://mainMenu/MainMenu.tscn")
