class_name Player

var name: String
var flag: String
var index: int

var throw: int = 0
var throwList = Array([], TYPE_INT, "", null)
var scoreList = Array([], TYPE_INT, "", null)
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

#Global Stats
var allTimeAveragePerLeg: float
var allTimeAveragePerThrow: float
var allTimeThrow: int
var allTimeDart: int
var allTimeScore80: int
var allTimeScore100: int
var allTimeScore140: int
var allTimeScore180: int
var allTimeLeg: int
var allTimeLegWin: int
var allTimeTotalScore: int

	
## Create a Player object with a name and flag.
func newPlayer(nameInput:String, flagInput: String) -> void:
	self.name = nameInput
	self.flag = flagInput
	

##Copy data from a player.
func loadFrom(player: Player) -> void:
	self.name = player.name
	self.flag = player.flag
	self.allTimeAveragePerLeg = player.allTimeAveragePerLeg
	self.allTimeAveragePerThrow = player.allTimeAveragePerThrow
	self.allTimeThrow = player.allTimeThrow
	self.allTimeDart = player.allTimeDart
	self.allTimeScore80 = player.allTimeScore80
	self.allTimeScore100 = player.allTimeScore100
	self.allTimeScore140 = player.allTimeScore140
	self.allTimeScore180 = player.allTimeScore180
	self.allTimeLeg = player.allTimeLeg
	self.allTimeLegWin = player.allTimeLegWin
	self.allTimeTotalScore = player.allTimeTotalScore
	self.index = len(GlobalData.playerList) - 1
	
##Load data from a dictionary.
func import(dic: Dictionary) -> void:
	self.name = dic.name
	self.flag = dic.flag
	self.allTimeAveragePerLeg = dic.allTimeAveragePerLeg
	self.allTimeAveragePerThrow = dic.allTimeAveragePerThrow
	self.allTimeThrow = dic.allTimeThrow
	self.allTimeDart = dic.allTimeDart
	self.allTimeScore80 = dic.allTimeScore80
	self.allTimeScore100 = dic.allTimeScore100
	self.allTimeScore140 = dic.allTimeScore140
	self.allTimeScore180 = dic.allTimeScore180
	self.allTimeLeg = dic.allTimeLeg
	self.allTimeLegWin = dic.allTimeLegWin
	self.allTimeTotalScore = dic.allTimeTotalScore
	self.index = len(GlobalData.playerList) - 1
	
##Export data into a Dictionary
func export() -> Dictionary:
	var output = {
		'name' = self.name,
		'flag' = self.flag,
		'allTimeAveragePerLeg' = self.allTimeAveragePerLeg,
		'allTimeAveragePerThrow' = self.allTimeAveragePerThrow,
		'allTimeThrow' = self.allTimeThrow,
		'allTimeDart' = self.allTimeDart,
		'allTimeScore80' = self.allTimeScore80,
		'allTimeScore100' = self.allTimeScore100,
		'allTimeScore140' = self.allTimeScore140,
		'allTimeScore180' = self.allTimeScore180,
		'allTimeLeg' = self.allTimeLeg,
		'allTimeLegWin' = self.allTimeLegWin,
		'allTimeTotalScore' = self.allTimeTotalScore
	}
	return output

##Strange Bug with this
func _to_string() -> String:
	return self.name + ": " + str(self.throwList)

##Set game related var to 0.
func newGame(targetScoreInput: int) -> void:

	self.throw = 0
	self.numberOfTurn = 0
	
	self.nbLeg = 0
	self.nbSet
	self.average = 0.0
	self.averagePerLeg = 0.0
	
	self.targetScore = targetScoreInput
	self.score = self.targetScore

func newLeg(targetScoreInput: int) -> void:
	
	self.throw = 0
	self.numberOfTurn = 0
	
	self.targetScore = targetScoreInput
	self.score = self.targetScore

##Return 0 if won, 1 if > 0 and -1 if bust
func newThrow(newThrowTotal: int) -> int:
	self.throw = newThrowTotal
	self.score = self.score - newThrowTotal
	
	if self.score >= 0:
		if newThrowTotal >= 80:
			if newThrowTotal >= 180:
				self.score180 += 1
			elif newThrowTotal >= 140:
				self.score140 += 1
			elif newThrowTotal >= 100:
				self.score100 += 1
			else:
				self.score80 += 1
		
		self.throwList.append(self.throw)
		self.scoreList.append(self.score)

		if self.score > 0:
			return 1
		else:
			return 0
	else:
		self.throw = 0
		self.throwList.append(self.throw)
		self.score = self.scoreList[-1]
		self.scoreList.append(self.score)
		return -1
