extends Button

func _ready():
	pass

func _on_pressed():
	var parent_node = self.get_node("/root/GameSelection")
	var name = $PanelContainer/HBoxContainer/Name.text
	for key in GlobalData.player_list.keys():
		if key in GlobalData.player_selected and key.to_lower() == $PanelContainer/HBoxContainer/Name.text.to_lower() :
			GlobalData.player_selected.erase(key)
			parent_node.create_player_list()
		elif key.to_lower() == $PanelContainer/HBoxContainer/Name.text.to_lower() :
			GlobalData.player_selected[str(name)] = GlobalData.player_list[str(name)]
			parent_node.create_player_list()
			return
