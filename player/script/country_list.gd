extends PanelContainer

@export var country_name: Node
@export var country_flag: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_country_name_pressed():
	self.get_parent().parent._on_item_list_item_selected(country_name.text, country_flag.get_texture())
