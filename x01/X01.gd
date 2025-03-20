extends Control

@export var dartboard: Control
@export var dartScore: Control
@export var dartScoreBtn: HBoxContainer
@export var infoPanel: VBoxContainer 
@export var nextPlayerPanel: MarginContainer

var setting: X01Settings
var playerList: Array[PlayerX01] = []
var currentPlayer: PlayerX01
var PlayerStartLegIndex: int = 0
var PlayerStartSetIndex: int = 0

## Make the difference between the difference type of button pressed.
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

## Initiate the differents btn with their corresponding functions.
func button_init() -> void:
	for group: Control in dartboard.controlGroupList:
		for btn in group.get_children():
			if btn is TextureButton:
				btn.pressed.connect(Callable(self, "dartboardButton").bind(btn, "input"))
				
	for btn: Button in dartScoreBtn.get_children():
		btn.pressed.connect(Callable(self, "dartboardButton").bind(btn, "scoreSetting"))
		
	for btn: TextureButton in dartScore.buttonList:
		btn.pressed.connect(Callable(self, "dartboardButton").bind(btn, "dartScore"))

## Toggle the status of buttons.
func toggleInput() -> void:
	for group: Control in dartboard.controlGroupList:
		for btn in group.get_children():
			if btn is TextureButton:
				btn.disabled = !btn.disabled;
				
	for btn: Button in dartScoreBtn.get_children():
		btn.disabled = !btn.disabled;
		
	for btn: TextureButton in dartScore.buttonList:
		btn.disabled = !btn.disabled;

## Return the following player in the SelectedPlayerList. Need the current player in the parameters.
func getNextPlayer(currentPlayerInput: PlayerX01) -> PlayerX01:
	var index = playerList.find(currentPlayerInput)
	if index + 1 < len(playerList):
		return playerList[index + 1]
	else:
		return playerList[0]

## Start the game.
func initGame() -> void:
	
	for elem: PlayerX01 in playerList:
		elem.newGame(setting.score)

	currentPlayer = playerList[0]
	
	infoPanel.setup(currentPlayer, setting)
	
	nextPlayerPanel.nextPlayer(getNextPlayer(currentPlayer))

## Load a new leg when needed.
func newLeg() -> void:
	
	for elem: PlayerX01 in playerList:
		elem.newLeg(setting.score)
	
	infoPanel.setup(currentPlayer, setting)
	
	nextPlayerPanel.nextPlayer(getNextPlayer(currentPlayer))

## Decided what to do when a player has finished his turn.
func endTurn(throwScore: int) -> void:
	
	var throwBool:int = currentPlayer.newThrow(throwScore)
	
	infoPanel.scoreLabel.text = str(currentPlayer.score)
	
	infoPanel.historyContainer.update(currentPlayer)
	infoPanel.statisticContainer.update(currentPlayer)
	
	# Reset the darts to empty 
	for dartValue in dartScore.buttonList:
		dartValue.label.text = ""
		dartValue.value = 0
	
	# If user has not finish the leg
	if throwBool != 0:
		var timer := Timer.new()
		timer.timeout.connect(nextTurn)
		timer.timeout.connect(timer.queue_free)
		timer.wait_time = 0.5 # 1 second
		timer.one_shot = true # don't loop, run once
		timer.autostart = true
		add_child(timer)
	else: #if user has finished the leg
		legWon()
		

## Load the setup for the next Turn.
func nextTurn() -> void:
	
	currentPlayer = getNextPlayer(currentPlayer)
	
	infoPanel.playerName.text = currentPlayer.player.name
	infoPanel.playerFlag.set_texture(load(currentPlayer.player.flag)) 
	infoPanel.scoreLabel.text = str(currentPlayer.score)
	infoPanel.checkOutLabel.text = ""
	
	infoPanel.statisticContainer.fromPlayer(currentPlayer)
	infoPanel.historyContainer.clear()
	infoPanel.historyContainer.update(currentPlayer)

	nextPlayerPanel.nextPlayer(getNextPlayer(currentPlayer))
	
## When a leg is won, decide if the game is finished or not.
func legWon() -> void:
	currentPlayer.nbLeg += 1
	if currentPlayer.nbLeg >= float(setting.totalLeg) / 2:
		currentPlayer.nbSet += 1
		if currentPlayer.nbSet >= float(setting.totalSet) / 2:
			print("GG")
			toggleInput()
		else:
			PlayerStartSetIndex = PlayerStartSetIndex + 1 if PlayerStartSetIndex + 1 < len(playerList) else 0
			currentPlayer = playerList[PlayerStartSetIndex]
			newLeg()
	else:
		PlayerStartLegIndex = PlayerStartLegIndex + 1 if PlayerStartLegIndex + 1 < len(playerList) else 0
		currentPlayer = playerList[PlayerStartLegIndex]
		newLeg()

## Called when the scene is ready.
func _ready() -> void:
	setting = GlobalData.setting.x01
	if len(GlobalData.setting.x01.selectedPlayerIndex) < 2:
		playerList.append(Player.new())
		playerList[0].newPlayer("Mattieu", "xxx")
		playerList.append(Player.new())
		playerList[1].newPlayer("Krek", "xxx")
	else:
		for index in setting.selectedPlayerIndex:
			playerList.append(PlayerX01.new())
			playerList[-1].init(GlobalData.playerList[index])
	
	button_init()
	
	initGame()
