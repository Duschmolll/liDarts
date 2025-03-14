extends Control

@export var dartboard: Control
@export var dartScore: Control
@export var dartScoreBtn: HBoxContainer
@export var infoPanel: VBoxContainer 
@export var nextPlayerPanel: MarginContainer


var playerList: Array[Player] = []
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

func toggleInput() -> void:
	for group: Control in dartboard.controlGroupList:
		for btn in group.get_children():
			if btn is TextureButton:
				btn.disabled = !btn.disabled;
				
	for btn: Button in dartScoreBtn.get_children():
		btn.disabled = !btn.disabled;
		
	for btn: TextureButton in dartScore.buttonList:
		btn.disabled = !btn.disabled;
		
func getNextPlayer(currentPlayerInput: Player) -> Player:
	var index = playerList.find(currentPlayerInput)
	if index + 1 < len(playerList):
		return playerList[index + 1]
	else:
		return playerList[0]
	
func initGame() -> void:
	
	for player: Player in playerList:
		player.newGame(301)

	currentPlayer = playerList[0]
	
	infoPanel.playerName.text = currentPlayer.name
	infoPanel.playerFlag.set_texture(load(currentPlayer.flag)) 
	infoPanel.scoreLabel.text = "301"
	infoPanel.checkOutLabel.text = ""
	
	infoPanel.statisticContainer.fromPlayer(currentPlayer)
	infoPanel.historyContainer.newGame()
	
	nextPlayerPanel.nextPlayer(getNextPlayer(currentPlayer))

func endTurn(throwScore: int) -> void:
	
	var throwBool:int = currentPlayer.newThrow(throwScore)
	for elem in playerList:
		print(elem)
		
	infoPanel.scoreLabel.text = str(currentPlayer.score)
	
	infoPanel.historyContainer.update(currentPlayer)
	infoPanel.statisticContainer.update(currentPlayer)
	
	for dartValue in dartScore.buttonList:
		dartValue.label.text = ""
		dartValue.value = 0
	
	if throwBool != 0:
		var timer := Timer.new()
		timer.timeout.connect(nextTurn)
		timer.timeout.connect(timer.queue_free)
		timer.wait_time = 0.5 # 1 second
		timer.one_shot = true # don't loop, run once
		timer.autostart = true
		add_child(timer)
	else:
		print("GG")
		toggleInput()
	
func nextTurn() -> void:
	
	currentPlayer = getNextPlayer(currentPlayer)
	
	infoPanel.playerName.text = currentPlayer.name
	infoPanel.playerFlag.set_texture(load(currentPlayer.flag)) 
	infoPanel.scoreLabel.text = str(currentPlayer.score)
	infoPanel.checkOutLabel.text = ""
	
	infoPanel.statisticContainer.fromPlayer(currentPlayer)
	infoPanel.historyContainer.clear()
	infoPanel.historyContainer.update(currentPlayer)

	nextPlayerPanel.nextPlayer(getNextPlayer(currentPlayer))
	
	
func _ready() -> void:
	if len(GlobalData.setting.x01.selectedPlayerIndex) < 2:
		playerList.append(Player.new())
		playerList[0].newPlayer("Mattieu", "xxx")
		playerList.append(Player.new())
		playerList[1].newPlayer("Krek", "xxx")
	else:
		for index in GlobalData.setting.x01.selectedPlayerIndex:
			playerList.append(Player.new())
			playerList[-1].loadFrom(GlobalData.playerList[index])
	
	button_init()
	
	initGame()
