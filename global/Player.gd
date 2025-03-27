class_name Player

var name: String
var flag: String
var index: int

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
var allTimeSet: int
var allTimeSetWin: int

	
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
	self.allTimeSet = player.allTimeSet
	self.allTimeSetWin = player.allTimeSetWin
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
	self.allTimeSet = dic.allTimeSet
	self.allTimeSetWin = dic.allTimeSetWin
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
		'allTimeTotalScore' = self.allTimeTotalScore,
		'allTimeSet' = self.allTimeSet,
		'allTimeSetWin' = self.allTimeSetWin
	}
	return output

##Strange Bug with this
func _to_string() -> String:
	return self.name + ": " + str(self.throwList)
