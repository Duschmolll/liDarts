extends Button

@export var player_name: Label

func _on_pressed():
	var parent_node = self.get_node("/root/Statistic")
	parent_node.get_statistic(player_name.text)
