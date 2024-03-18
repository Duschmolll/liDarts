extends Control
#TODO: Stats
var anim_can_up = true
@export var selected_grid: Node
@export var unselected_grid: Node
@export var split_container: Node
@export var x01_Canvas_Layer: Node
@export var x01_Gamemode_Button: Node
@export var x01_Spin_Box: Node

func _ready():
	create_player_list()
	GlobalData.load_data("user://data/data.json")

func _process(delta):
	if Input.is_action_just_pressed("InGameMenu"):
			get_tree().change_scene_to_file("res://main_menu.tscn")

func create_player_list():
	const PLAYER_LIST = preload("res://gamemode/scene/player_list_button.tscn")
	var unselected_child = unselected_grid.get_children()
	var selected_child = selected_grid.get_children()
	
	if len(unselected_child) > 0:
		for i in range(0, len(unselected_child)):
			unselected_grid.remove_child(unselected_child[i])	
	
	if len(selected_child) > 0:
		for i in range(0, len(selected_child)):
			selected_grid.remove_child(selected_child[i])
	
	if len(GlobalData.player_list.keys()) > 0:
		var i = 0
		for key in GlobalData.player_list.keys():
			if key in GlobalData.player_selected:
				pass
			else:
				var instance = PLAYER_LIST.instantiate()
				unselected_grid.add_child(instance)
				unselected_grid.get_children()[i].get_children()[0].get_children()[0].get_children()[1].text = GlobalData.player_list[key].name
				unselected_grid.get_children()[i].get_children()[0].get_children()[0].get_children()[0].get_children()[0].set_texture(load(GlobalData.player_list[key].flag))
				i += 1
	
	if len(GlobalData.player_selected.keys()) > 0:
		var i = 0
		for key in GlobalData.player_selected.keys():
				var instance = PLAYER_LIST.instantiate()
				selected_grid.add_child(instance)
				selected_grid.get_children()[i].get_children()[0].get_children()[0].get_children()[1].text = GlobalData.player_selected[key].name
				selected_grid.get_children()[i].get_children()[0].get_children()[0].get_children()[0].get_children()[0].set_texture(load(GlobalData.player_selected[key].flag))
				i += 1


func _on_v_box_container_mouse_entered():
	var offset = split_container.get_split_offset()
	while offset >= 200:
		await get_tree().create_timer(0.01).timeout
		offset -= 5
		split_container.set_split_offset (offset)
	anim_can_up = false


func _on_v_box_container_2_mouse_entered():
	if !anim_can_up:
		var offset = split_container.get_split_offset()
		while offset <= 350:
			await get_tree().create_timer(0.01).timeout
			offset += 5
			split_container.set_split_offset (offset)
		anim_can_up = true


func _on_x01_button_pressed(gamemode: String):
	if gamemode == "main":
		if x01_Canvas_Layer.visible:
			x01_Canvas_Layer.visible = false
		else:
			x01_Canvas_Layer.visible = true
	else:
		x01_Canvas_Layer.visible = false
		x01_Gamemode_Button.text = gamemode
		GlobalData.setting["x01"].score = str(gamemode)

func _on_x01_setting_pressed(toggled: bool,setting: String):
	match setting:
		"Double-In":
			GlobalData.setting["x01"].double_in = toggled
		"Double-Out":
			GlobalData.setting["x01"].double_out = toggled
		"Show Check-Out":
			GlobalData.setting["x01"].show_check_out = toggled
		_:
			printerr(setting)

func _on_X01_setting_input(input: float, setting: String):
	match setting:
		"Leg":
			GlobalData.setting["x01"].total_leg = int(input)
		"Set":
			GlobalData.setting["x01"].total_set = int(input)
		"Inf":
			if x01_Spin_Box.editable:
				GlobalData.setting["x01"].total_leg = 1000
			else:
				GlobalData.setting["x01"].total_leg =  x01_Spin_Box.get_value()
			x01_Spin_Box.editable = not x01_Spin_Box.editable
		_:
			printerr(setting)

func _on_play_pressed(gamemode: String):
	GlobalData.save_data("user://data/data.json")
	match gamemode:
		"x01":
			match len(GlobalData.player_selected):
				0: 
					create_error("Wait", "You need to select player")
				1:
					create_error("Wait", "There is not enough player selected.")
				2:
					get_tree().change_scene_to_file("res://gamemode/x_01/x_01_duo.tscn")
				_:
					create_error("Wait", "W.I.P. Err: " + str(len(GlobalData.player_selected)))
		_:
			printerr(gamemode)
			
func create_error(title: String, desc: String):
	const error_scene = preload("res://error_popup.tscn")
	var instance = error_scene.instantiate()
	instance.get_node('CenterContainer/PanelContainer/VBoxContainer/PanelContainer/Title').text = title
	instance.get_node('CenterContainer/PanelContainer/VBoxContainer/Desc').text = desc
	self.add_child(instance)


func _on_add_player_pressed():
	const add_player_scene = preload("res://add_player.tscn")
	var instance = add_player_scene.instantiate()
	instance.parent = self
	self.add_child(instance)

func player_list_updated():
	create_player_list()

