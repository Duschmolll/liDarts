extends Control



func _on_play_pressed():
	get_tree().change_scene_to_file("res://gamemode/game_selection.tscn")


func _on_settings_pressed():
	pass # Replace with function body.


func _on_statistique_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()


func _on_players_pressed():
	get_tree().change_scene_to_file("res://player/player_menu.tscn")
