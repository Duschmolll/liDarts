extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_country_name_pressed():
	var country_name = $HBoxContainer/CountryName.text
	var country_flag = $HBoxContainer/MarginContainer/Flag.get_texture()
	var master = get_node("/root").get_children()[0]
	master._on_item_list_item_selected(country_name, country_flag)
	pass # Replace with function body.
