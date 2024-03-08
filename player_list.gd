extends AspectRatioContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	var parent_node = self.get_node("/root/PlayerMenu")
	#print(global_data.number_of_player)
	#for i in range(1, global_data.number_of_player + 1):
		#if global_data.player_list['player_' + str(i)].name == $PanelContainer/HBoxContainer/Name.text:
			#global_data.player_list.erase('player_' + str(i))
			#print(global_data.player_list)
	#self.queue_free()
	for key in parent_node.global_data.player_list.keys():
		if key.to_lower() == $PanelContainer/HBoxContainer/Name.text.to_lower() :
			parent_node.global_data.player_list.erase(key)
			parent_node._createPlayerList()
			parent_node.save_data(parent_node.SAVE_DIR + parent_node.SAVE_FILE_NAME)
			return
					
	pass # Replace with function body.
