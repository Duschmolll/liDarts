extends Control

const SAVE_DIR = "user://data/"
const SAVE_FILE_NAME = "data.json"
const SECURITY_KEY = "0EZASQ"

@export var button_canvas: CanvasLayer
@export var player_grid: GridContainer

#TODO: Remake the create player button to be call from another scene
func _ready():
	createPlayerList()

func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://mainMenu/main_menu.tscn")


func _on_new_player_pressed():
	const add_player_scene = preload("res://player/add_player.tscn")
	var instance = add_player_scene.instantiate()
	instance.parent = self
	self.add_child(instance)


func createPlayerList():
	const PLAYER_LIST = preload("res://player/player_list.tscn")
	var grid_children = player_grid.get_children()
	if len(grid_children) > 0:
		for i in range(0, len(grid_children)):
			player_grid.remove_child(grid_children[i])
	if len(GlobalData.playerList) > 0:
		var i = 0
		for elem in GlobalData.playerList:
			var instance = PLAYER_LIST.instantiate()
			instance.nameLabel.text = elem.name
			instance.flagTextureRect.set_texture(load(elem.flag))
			player_grid.add_child(instance)
			i += 1


func player_list_updated():
	createPlayerList()
