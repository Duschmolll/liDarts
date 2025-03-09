class_name Player

var name: String
var flag: String
var index: int

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

	
## Create a Player object with a name and flag.
func newPlayer(name:String, flag: String) -> void:
	self.name = name
	self.flag = flag
	

##Copy data from a player.
func loadFrom(player: Player) -> void:
	self.all_time_average_per_leg = player.all_time_average_per_leg
	self.all_time_average_per_throw = player.all_time_average_per_throw
	self.all_time_throw = player.all_time_throw
	self.all_time_dart = player.all_time_dart
	self.all_time_score_80 = player.all_time_score_80
	self.all_time_score_100 = player.all_time_score_100
	self.all_time_score_140 = player.all_time_score_140
	self.all_time_score_180 = player.all_time_score_180
	self.all_time_leg = player.all_time_leg
	self.all_time_leg_win = player.all_time_leg_win
	self.all_time_total_score = player.all_time_total_score
	self.index = len(GlobalData.playerList) - 1
	
##Load data from a dictionary.
func import(dic: Dictionary) -> void:
	self.name = dic.name
	self.flag = dic.flag
	self.all_time_average_per_leg = dic.all_time_average_per_leg
	self.all_time_average_per_throw = dic.all_time_average_per_throw
	self.all_time_throw = dic.all_time_throw
	self.all_time_dart = dic.all_time_dart
	self.all_time_score_80 = dic.all_time_score_80
	self.all_time_score_100 = dic.all_time_score_100
	self.all_time_score_140 = dic.all_time_score_140
	self.all_time_score_180 = dic.all_time_score_180
	self.all_time_leg = dic.all_time_leg
	self.all_time_leg_win = dic.all_time_leg_win
	self.all_time_total_score = dic.all_time_total_score
	self.index = len(GlobalData.playerList) - 1
	
##Export data into a Dictionary
func export() -> Dictionary:
	var output = {
		'name' = self.name,
		'flag' = self.flag,
		'all_time_average_per_leg' = self.all_time_average_per_leg,
		'all_time_average_per_throw' = self.all_time_average_per_throw,
		'all_time_throw' = self.all_time_throw,
		'all_time_dart' = self.all_time_dart,
		'all_time_score_80' = self.all_time_score_80,
		'all_time_score_100' = self.all_time_score_100,
		'all_time_score_140' = self.all_time_score_140,
		'all_time_score_180' = self.all_time_score_180,
		'all_time_leg' = self.all_time_leg,
		'all_time_leg_win' = self.all_time_leg_win,
		'all_time_total_score' = self.all_time_total_score
	}
	return output

##Strange Bug with this
func _to_string() -> String:
	return self.name + ": " + str(self.throwList)

##Set game related var to 0.
func newGame(targetScore: int) -> void:

	self.throw = 0
	self.number_of_turn = 0
	
	self.leg = 0
	self.average = 0.0
	self.average_per_leg = 0.0
	
	self.target_score = targetScore
	self.score = self.target_score

##Return 0 if won, 1 if > 0 and -1 if bust
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
