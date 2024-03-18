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
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_new_player_pressed():
	const add_player_scene = preload("res://add_player.tscn")
	var instance = add_player_scene.instantiate()
	instance.parent = self
	self.add_child(instance)


func createPlayerList():
	const PLAYER_LIST = preload("res://player/scene/player_list.tscn")
	var grid_children = player_grid.get_children()
	if len(grid_children) > 0:
		for i in range(0, len(grid_children)):
			player_grid.remove_child(grid_children[i])
	if len(GlobalData.player_list.keys()) > 0:
		var i = 0
		for key in GlobalData.player_list.keys():
			var instance = PLAYER_LIST.instantiate()
			player_grid.add_child(instance)
			player_grid.get_children()[i].get_children()[0].get_children()[0].get_children()[1].text = GlobalData.player_list[key].name
			player_grid.get_children()[i].get_children()[0].get_children()[0].get_children()[0].get_children()[0].set_texture(load(GlobalData.player_list[key].flag))
			i += 1


func player_list_updated():
	createPlayerList()
