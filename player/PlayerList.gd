extends AspectRatioContainer

@export var nameLabel:Label
@export var flagTextureRect: TextureRect

@export var buttonEdit: TextureButton
@export var buttonValidate: TextureButton
@export var buttonDelete: TextureButton
@export var buttonCancel: TextureButton

var player: Player

func _ready():
	buttonCancel.visible = false
	buttonDelete.visible = true
	buttonEdit.visible = true
	buttonValidate.visible = false

func setup(playerInput: Player):
	nameLabel.text = playerInput.name
	flagTextureRect.set_texture(load(playerInput.flag))
	player = playerInput

func _on_button_cancel_pressed():
	buttonCancel.visible = false
	buttonDelete.visible = true
	buttonEdit.visible = true
	buttonValidate.visible = false


func _on_button_delete_pressed():
	buttonCancel.visible = true
	buttonDelete.visible = false
	buttonEdit.visible = false
	buttonValidate.visible = true 

func _on_button_validate_pressed():
	for i in range(len(GlobalData.playerList)):
		var elem = GlobalData.playerList[i]
		if elem == self.player:
			GlobalData.playerList.remove_at(i)
			self.get_node("/root/PlayerMenu").createPlayerList()
			GlobalData.save_data(GlobalData.SAVE_DIR + GlobalData.SAVE_FILE_NAME)
			break
