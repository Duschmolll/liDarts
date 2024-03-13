extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_country_name_pressed():
	var country_name = $HBoxContainer/CountryName.text
	var country_flag = $HBoxContainer/MarginContainer/Flag.get_texture()
	var master = get_node("/root").get_children()[1]
	master._on_item_list_item_selected(country_name, country_flag)
