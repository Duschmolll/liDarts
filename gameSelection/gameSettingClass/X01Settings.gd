class_name X01Settings

var type: String = "x01"
var score: int = 501
var totalLeg: int = 1
var totalSet: int = 0
var doubleIn: bool = false
var doubleOut: bool = false
var showCheckOut: bool = false
var selectedPlayerIndex: Array[int] = []

## Copy data from another X01Setting object
func importSettings(setting: X01Settings) -> void:
	self.score = setting.score
	self.totalLeg = setting.totalLeg
	self.totalSet = setting.totalSet
	self.doubleIn = setting.doubleIn
	self.doubleOut = setting.doubleOut
	self.showCheckOut = setting.showCheckOut
	self.selectedPlayerIndex = setting.selectedPlayerIndex

## Copy data from a dict
func importDict(dic: Dictionary) -> void:
	self.score = dic.score
	self.totalLeg = dic.totalLeg
	self.totalSet = dic.totalSet
	self.doubleIn = dic.doubleIn
	self.doubleOut = dic.doubleOut
	self.showCheckOut = dic.showCheckOut
	for index in dic.selectedPlayerIndex:
		self.selectedPlayerIndex.append(index)

## Export Object into a Dictionary
func exportDict() -> Dictionary:
	var dict: Dictionary = {
		'type' = self.type,
		'score' = self.score,
		'totalLeg' = self.totalLeg,
		'totalSet' = self.totalSet,
		'doubleIn' = self.doubleIn,
		'doubleOut' = self.doubleOut,
		'showCheckOut' = self.showCheckOut,
		'selectPlayerIndex' = self.selectedPlayerIndex
	}
	return dict
	
