extends Control

const SAVE_DIR = "user://data/"
const SAVE_FILE_NAME = "data.json"
const SECURITY_KEY = "0EZASQ"

#var global_data: GlobalData = GlobalData.new()

@onready var canvas: CanvasLayer = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas


func _ready():
	createPlayerList()
	create_flag_list()


func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_new_player_pressed():
	if canvas.visible:
		canvas.visible = false
	else: 
		canvas.visible = true


func createPlayerList():
	var grid = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/PlayerListContainer/PanelContainer/MarginContainer/PlayerListControl/PlayerListGrid
	const PLAYER_LIST = preload("res://player/scene/player_list.tscn")
	var grid_children = grid.get_children()
	if len(grid_children) > 0:
		for i in range(0, len(grid_children)):
			grid.remove_child(grid_children[i])
	if len(GlobalData.player_list.keys()) > 0:
		var i = 0
		for key in GlobalData.player_list.keys():
			var instance = PLAYER_LIST.instantiate()
			grid.add_child(instance)
			grid.get_children()[i].get_children()[0].get_children()[0].get_children()[1].text = GlobalData.player_list[key].name
			grid.get_children()[i].get_children()[0].get_children()[0].get_children()[0].get_children()[0].set_texture(load(GlobalData.player_list[key].flag))
			i += 1


func _on_button_pressed():
	var player: Player = Player.new()
	var name_line: LineEdit = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas/PanelContainer/MarginContainer/CreatePlayer/HBoxContainer/LineEditName
	var country_flag: TextureRect = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas/PanelContainer/MarginContainer/CreatePlayer/HBoxContainer2/MarginContainer/Flag
	var country_name: LineEdit = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas/PanelContainer/MarginContainer/CreatePlayer/HBoxContainer2/LineEditCountry
	var name: String = name_line.text
	var re = RegEx.new()
	re.compile("[\\d\\s]+")
	var result = re.search(name)

	if len(name) > 3:
		if result:
			if result.get_string() != "" || name == "":
				name_line.clear()
				name_line.placeholder_text= "Invalid Name"

		else:
			for key in GlobalData.player_list.keys():
				if key.to_lower() == name.to_lower() :
					name_line.clear()
					name_line.placeholder_text= "Name already taken"
					return
					
			GlobalData.player_list[str(name)] = Player.new()
			GlobalData.player_list[str(name)].name = name
			GlobalData.player_list[str(name)].flag = country_flag.texture.resource_path
			GlobalData.save_data(SAVE_DIR + SAVE_FILE_NAME)
			name_line.clear()
			country_flag.set_texture(load("res://texture/countryFlag/World_Wide.png"))
			country_name.text = ""
			name_line.placeholder_text = "Name"
			canvas.visible = false
			createPlayerList()
	else:
		name_line.clear()
		name_line.placeholder_text= "Name too short"


func create_flag_list():
	var item_list: ItemList = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas/PanelContainer/MarginContainer/CreatePlayer/ItemList
	var scroll_child = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas/PanelContainer/MarginContainer/CreatePlayer/ScrollContainer/VBoxContainer
	const COUNTRY_LIST = preload("res://player/scene/country_list.tscn")
	var countries = get_all_flag()
	var i = 0
	
	for key in countries.keys():
		var instance = COUNTRY_LIST.instantiate()
		scroll_child.add_child(instance)
		scroll_child.get_children()[i].get_children()[0].get_children()[0].get_children()[0].set_texture(load(countries[key].path))
		scroll_child.get_children()[i].get_children()[0].get_children()[1].text = countries[key].name
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
	var country_scroll: ScrollContainer = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas/PanelContainer/MarginContainer/CreatePlayer/ScrollContainer
	var flag:TextureRect = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas/PanelContainer/MarginContainer/CreatePlayer/HBoxContainer2/MarginContainer/Flag
	var input: LineEdit = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas/PanelContainer/MarginContainer/CreatePlayer/HBoxContainer2/LineEditCountry
	flag.set_texture(country_flag)
	input.text = country_name
	country_scroll.visible = false


func _on_line_edit_country_focus_entered():
	var country_scroll: ScrollContainer = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas/PanelContainer/MarginContainer/CreatePlayer/ScrollContainer
	$MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas/PanelContainer/MarginContainer/CreatePlayer/HBoxContainer2/LineEditCountry.text = ""
	_on_line_edit_country_text_changed("")
	country_scroll.visible = true


func _on_line_edit_country_text_changed(new_text):
	var flag: VBoxContainer = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas/PanelContainer/MarginContainer/CreatePlayer/ScrollContainer/VBoxContainer
	var country_input: LineEdit = $MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas/PanelContainer/MarginContainer/CreatePlayer/HBoxContainer2/LineEditCountry
	for i in flag.get_child_count():
		var country_name_btn = flag.get_children()[i].get_children()[0].get_children()[1]
		if !country_name_btn.text.to_lower().begins_with(country_input.text.to_lower()):
			flag.get_children()[i].visible = false
		else:
			flag.get_children()[i].visible = true
	flag.visible = true


func _on_line_edit_name_focus_entered():
		$MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/AddPlayerContainer/PanelContainer/PlayerCanvas/PanelContainer/MarginContainer/CreatePlayer/ScrollContainer.visible = false
