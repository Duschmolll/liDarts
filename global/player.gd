class_name Player

var name: String
var flag: String

var throw: int = 0
var throwList = Array([], TYPE_INT, "", null)
var scoreList = Array([], TYPE_INT, "", null)
var number_of_turn: int = 0

var score: int = 0
var target_score: int = 0

var leg: int = 0
var average: float = 0.0
var average_per_leg: float = 0.0


var score_80: int = 0
var score_100: int = 0
var score_140: int = 0
var score_180: int = 0

#Global Stats
var all_time_average_per_leg: float
var all_time_average_per_throw: float
var all_time_throw: int
var all_time_dart: int
var all_time_score_80: int
var all_time_score_100: int
var all_time_score_140: int
var all_time_score_180: int
var all_time_leg: int
var all_time_leg_win: int
var all_time_total_score: int

func _init(name:String, flag: String) -> void:
	self.name = name
	self.flag = flag

func _to_string() -> String:
	return str(self.throwList)
	
func newGame(targetScore: int) -> void:

	self.throw = 0
	self.number_of_turn = 0
	
	self.leg = 0
	self.average = 0.0
	self.average_per_leg = 0.0
	
	self.target_score = targetScore
	self.score = self.target_score

func newThrow(newThrow: int) -> int:
	self.throw = newThrow
	self.score = self.score - newThrow
	
	if self.score >= 0:
		if newThrow >= 80:
			if newThrow >= 180:
				self.score_180 += 1
			elif newThrow >= 140:
				self.score_140 += 1
			elif newThrow >= 100:
				self.score_100 += 1
			else:
				self.score_80 += 1
		
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
