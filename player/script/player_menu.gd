extends Control

const SAVE_DIR = "user://data/"
const SAVE_FILE_NAME = "data.json"
const SECURITY_KEY = "0EZASQ"

@export var button_canvas: CanvasLayer
@export var player_grid: GridContainer

#TODO: Remake the create player button to be call from another scene
func _ready():
	createPlayerList()
	create_flag_list()


func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_new_player_pressed():
	if button_canvas.visible:
		button_canvas.visible = false
	else: 
		button_canvas.visible = true


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


func _on_button_pressed():
	var player: Player = Player.new()
	var name: String = button_canvas.player_line.text
	var re = RegEx.new()
	re.compile("[\\d\\s]+")
	var result = re.search(name)

	if len(name) > 3:
		if result:
			if result.get_string() != "" || name == "":
				button_canvas.player_line.clear()
				button_canvas.player_line.placeholder_text= "Invalid Name"

		else:
			for key in GlobalData.player_list.keys():
				if key.to_lower() == name.to_lower() :
					button_canvas.player_line.clear()
					button_canvas.player_line.placeholder_text= "Name already taken"
					return
					
			GlobalData.player_list[str(name)] = Player.new()
			GlobalData.player_list[str(name)].name = name
			GlobalData.player_list[str(name)].flag = button_canvas.country_texture.texture.resource_path
			GlobalData.save_data(SAVE_DIR + SAVE_FILE_NAME)
			button_canvas.player_line.clear()
			button_canvas.country_texture.set_texture(load("res://texture/countryFlag/World_Wide.png"))
			button_canvas.country_line.text = ""
			button_canvas.player_line.placeholder_text = "Name"
			button_canvas.visible = false
			createPlayerList()
	else:
		button_canvas.player_line.clear()
		button_canvas.player_line.placeholder_text= "Name too short"


func create_flag_list():
	const COUNTRY_LIST = preload("res://player/scene/country_list.tscn")
	var countries = get_all_flag()
	var i = 0
	
	for key in countries.keys():
		var instance = COUNTRY_LIST.instantiate()
		button_canvas.country_scroll.get_children()[0].add_child(instance)
		button_canvas.country_scroll.get_children()[0].get_children()[i].get_children()[0].get_children()[0].get_children()[0].set_texture(load(countries[key].path))
		button_canvas.country_scroll.get_children()[0].get_children()[i].get_children()[0].get_children()[1].text = countries[key].name
		i += 1


func get_all_flag():
	var countries = {}
	var dir = DirAccess.open("res://texture/countryFlag")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.get_extension() == "png":
				countries[file_name.replace('.png','')] = {
					"name" = file_name.replace('.png','').replace('_', ' '),
					"path" = ("res://texture/countryFlag/" + file_name)
				}
			file_name = dir.get_next()
	else:
		printerr("An error occurred when trying to access the path.")
	return countries


func _on_item_list_item_selected(country_name,country_flag):
	button_canvas.country_texture.set_texture(country_flag)
	button_canvas.country_line.text = country_name
	button_canvas.country_scroll.visible = false


func _on_line_edit_country_focus_entered():
	button_canvas.country_line.text = ""
	_on_line_edit_country_text_changed("")
	button_canvas.country_scroll.visible = true


func _on_line_edit_country_text_changed(new_text):
	for i in button_canvas.country_scroll.get_children()[0].get_child_count():
		var country_name_btn = button_canvas.country_scroll.get_children()[0].get_children()[i].get_children()[0].get_children()[1]
		if !country_name_btn.text.to_lower().begins_with(button_canvas.country_line.text.to_lower()):
			button_canvas.country_scroll.get_children()[0].get_children()[i].visible = false
		else:
			button_canvas.country_scroll.get_children()[0].get_children()[i].visible = true
	button_canvas.country_scroll.get_children()[0].visible = true


func _on_line_edit_name_focus_entered():
		button_canvas.country_scroll.visible = false
