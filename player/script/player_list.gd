extends AspectRatioContainer

@onready var button_edit = $PanelContainer/HBoxContainer/MarginContainer3/ButtonEdit
@onready var button_validate = $PanelContainer/HBoxContainer/MarginContainer3/ButtonValidate
@onready var button_delete = $PanelContainer/HBoxContainer/MarginContainer4/ButtonDelete
@onready var button_cancel = $PanelContainer/HBoxContainer/MarginContainer4/ButtonCancel
var countries = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	button_cancel.visible = false
	button_delete.visible = true
	button_edit.visible = true
	button_validate.visible = false

func _on_button_cancel_pressed():
	button_cancel.visible = false
	button_delete.visible = true
	button_edit.visible = true
	button_validate.visible = false


func _on_button_delete_pressed():
	button_cancel.visible = true
	button_delete.visible = false
	button_edit.visible = false
	button_validate.visible = true
	pass # Replace with function body.


func _on_button_validate_pressed():
	var parent_node = self.get_node("/root/PlayerMenu")
	for key in parent_node.global_data.player_list.keys():
		if key.to_lower() == $PanelContainer/HBoxContainer/Name.text.to_lower() :
			parent_node.global_data.player_list.erase(key)
			parent_node._createPlayerList()
			parent_node.save_data(parent_node.SAVE_DIR + parent_node.SAVE_FILE_NAME)
			return


func _on_button_edit_pressed():
	pass
