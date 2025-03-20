class_name PlayerX01
## Class for making a Player with the variable for playing an X01.


var player: Player

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
func init(playerRef: Player):
	self.player = playerRef

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

## Reset the target & nb of Turn/Throw
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
