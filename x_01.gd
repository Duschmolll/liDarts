extends Control

@export var dartboard: Control
@export var dartScore: Control
@export var dartScoreBtn: HBoxContainer
@export var infoPanel: VBoxContainer 

var playerList = [Player.new("Mattieu", "xxx"), Player.new("Krek", "xxx")]
var currentPlayer: Player

func dartboardButton(btn, type) -> void:
	match type:
		"input":
			for dartValue in dartScore.buttonList:
				if dartValue.label.text == "":
					match btn.name:
						"Simple":
							dartValue.label.text = str(btn.buttonValue)
							dartValue.value = btn.buttonValue
						"Double":
							dartValue.label.text = str(btn.buttonValue/2) + "\n" + str(btn.buttonValue/2)
							dartValue.value = btn.buttonValue
						"Triple":
							dartValue.value = btn.buttonValue
							dartValue.label.text = str(btn.buttonValue/3) + "\n" + str(btn.buttonValue/3) + "\n" + str(btn.buttonValue/3)
					break;
					
		"scoreSetting":
			match btn.text:
				"Validate":
					var throwScore: int = 0
					for dartValue in dartScore.buttonList:
						throwScore += dartValue.value
					
					endTurn(throwScore)


				"Miss":
					for dartValue in dartScore.buttonList:
						if dartValue.label.text == "":
							dartValue.label.text = "MISS"
							dartValue.value = 0
							break
					
		"dartScore":
			btn.label.text = ""
			btn.value = 0
			
func button_init() -> void:
	for group: Control in dartboard.controlGroupList:
		for btn in group.get_children():
			if btn is TextureButton:
				btn.pressed.connect(Callable(self, "dartboardButton").bind(btn, "input"))
				
	for btn: Button in dartScoreBtn.get_children():
		btn.pressed.connect(Callable(self, "dartboardButton").bind(btn, "scoreSetting"))
		
	for btn: TextureButton in dartScore.buttonList:
		btn.pressed.connect(Callable(self, "dartboardButton").bind(btn, "dartScore"))

func initGame() -> void:
	
	for player: Player in playerList:
		player.newGame(301)

	currentPlayer = playerList[0]
	
	infoPanel.player_name.text = currentPlayer.name
	infoPanel.player_flag.set_texture(load(currentPlayer.flag)) 
	infoPanel.score_label.text = "301"
	infoPanel.check_out_label.text = ""
	
	infoPanel.statistic_container.fromPlayer(currentPlayer)
	infoPanel.history_container.newGame()

func endTurn(throwScore: int) -> void:
	
	var throwBool:int = currentPlayer.newThrow(throwScore)
	
	infoPanel.score_label.text = str(currentPlayer.score)
	
	infoPanel.history_container.update(currentPlayer)
	infoPanel.statistic_container.update(currentPlayer)
	
	for dartValue in dartScore.buttonList:
		dartValue.label.text = ""
		dartValue.value = 0
	
	
func _ready() -> void:
	button_init()
	
	initGame()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
