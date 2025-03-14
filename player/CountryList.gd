extends PanelContainer

@export var countryName: Button
@export var countryFlag: TextureRect

func _on_country_name_pressed():
	self.get_parent().parent._on_item_list_item_selected(countryName.text, countryFlag.get_texture())
