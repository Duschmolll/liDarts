extends AspectRatioContainer

@export var nameLabel:Label
@export var flagTextureRect: TextureRect

@onready var button_edit = $PanelContainer/HBoxContainer/MarginContainer3/ButtonEdit
@onready var button_validate = $PanelContainer/HBoxContainer/MarginContainer3/ButtonValidate
@onready var button_delete = $PanelContainer/HBoxContainer/MarginContainer4/ButtonDelete
@onready var button_cancel = $PanelContainer/HBoxContainer/MarginContainer4/ButtonCancel

var player: Player

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
	pass 


func _on_button_validate_pressed():
	for i in range(len(GlobalData.playerList)):
		var elem = GlobalData.playerList[i]
		if elem == self.player:
			GlobalData.playerList.remove_at(i)
			self.get_node("/root/PlayerMenu").createPlayerList()
			GlobalData.save_data(GlobalData.SAVE_DIR + GlobalData.SAVE_FILE_NAME)
			return


func _on_button_edit_pressed():
	pass
