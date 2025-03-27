class_name PlayerX01
## Class for making a Player with the variable for playing an X01.


var player: Player
var setting: X01Settings

var throw: int = 0
var throwList: Array[int] = []
var scoreList: Array[int] = []
var numberOfTurn: int = 0

var score: int = 0
var targetScore: int = 0

var nbSet: int = 0
var nbLeg: int = 0
var average: float = 0.0
var averagePerLeg: float = 0.0

var score80: int = 0
var score100: int = 0
var score140: int = 0
var score180: int = 0

## Link GamePlayer to Player
func init(playerRef: Player, settingRef: X01Settings):
	self.player = playerRef
	self.setting = settingRef

##Set game related var to 0.
func newGame(targetScoreInput: int) -> void:

	self.throw = 0
	self.numberOfTurn = 0
	
	self.nbLeg = 0
	
	self.average = 0.0
	self.averagePerLeg = 0.0
	
	self.targetScore = targetScoreInput
	self.score = self.targetScore

## Reset the target & nb of Turn/Throw
func newLeg(targetScoreInput: int) -> void:
	
	self.throw = 0
	self.numberOfTurn = 0
	
	self.targetScore = targetScoreInput
	self.score = self.targetScore
	self.throwList = []
	self.scoreList = []

## Return 0 if won, 1 if > 0 and -1 if bust
func newThrow(newThrowTotal: int, firstDouble: bool, lastDouble: bool) -> int:
	
	if (setting.doubleIn and firstDouble and self.score == self.targetScore) or (!setting.doubleIn) or (self.score != self.targetScore):
	## Check if the doubleIn is repescted, not enalbed or not an in throw
		self.throw = newThrowTotal
		self.score = self.score - newThrowTotal
		
		if self.score > 0:
		## if throw doest not finish game and is valide
			self.throwList.append(self.throw)
			self.scoreList.append(self.score)
			self.updateStat(newThrowTotal)
			return 1
		elif (self.setting.doubleOut and lastDouble) or (not self.setting.doubleOut):
		## If throw finish the game with/out the doubleOut.
			self.throwList.append(self.throw)
			self.scoreList.append(self.score)
			self.updateStat(newThrowTotal)
			return 0
		else:
		## if throw is out of bound or invalid.
			self.throw = 0
			self.throwList.append(self.throw)
			self.score = self.scoreList[-1]
			self.scoreList.append(self.score)
			return -1
	else:
	## DoubleIn not valid
		self.throw = 0
		self.throwList.append(self.throw)
		self.score = self.targetScore
		self.scoreList.append(self.score)
		return -1

## Update the stats about high value darts.
func updateStat(throw: int) -> void:
	if throw >= 80:
		if throw >= 180:
			self.score180 += 1
		elif throw >= 140:
			self.score140 += 1
		elif throw >= 100:
			self.score100 += 1
		else:
			self.score80 += 1

## Saving stat when a leg is done.
func saveStatLeg( winner: PlayerX01) -> void:
	self.player.allTimeLeg += 1
	if ( winner == self ):
		## if his the winner of the leg
		self.player.allTimeLegWin += 1
	
	for thr in self.throwList:
		self.average += thr
		
	self.player.allTimeTotalScore += self.average
	self.player.allTimeAveragePerThrow += self.average / len(self.throwList)
	self.player.allTimeAveragePerLeg += (self.average + self.player.allTimeAveragePerLeg) / self.player.allTimeLeg
	

	
	self.player.allTimeThrow += len(self.throwList)
	self.player.allTimeDart += len(self.throwList) * 3
	GlobalData.save_data(GlobalData.SAVE_DIR + GlobalData.SAVE_FILE_NAME)
	

## Save stat when game is done:
func saveStatGame(totalSet: int) -> void:
	self.player.allTimeScore80 += self.score80
	self.player.allTimeScore100 += self.score100
	self.player.allTimeScore140 += self.score140
	self.player.allTimeScore180 += self.score180
	
	self.player.allTimeSet += totalSet
	self.player.allTimeSetWin += self.nbSet
	GlobalData.save_data(GlobalData.SAVE_DIR + GlobalData.SAVE_FILE_NAME)
