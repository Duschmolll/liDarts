extends AspectRatioContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	var global_data = self.get_node("/root/PlayerMenu").global_data
	#print(global_data.number_of_player)
	#for i in range(1, global_data.number_of_player + 1):
		#if global_data.player_list['player_' + str(i)].name == $PanelContainer/HBoxContainer/Name.text:
			#global_data.player_list.erase('player_' + str(i))
			#print(global_data.player_list)
	#self.queue_free()
	
	pass # Replace with function body.
