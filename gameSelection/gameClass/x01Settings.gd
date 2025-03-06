class_name X01Settings

var type: String = "X01"
var score: int = 501
var total_leg: int = 1
var total_set: int = 0
var double_in: bool = false
var double_out: bool = false
var show_check_out: bool = false

func importSettings(setting: X01Settings) -> void:
	self.score = setting.score
	self.total_leg = setting.total_leg
	self.total_set = setting.total_set
	self.double_in = setting.double_in
	self.double_out = setting.double_out
	self.show_check_out = setting.show_check_out
	
func importDict(dic: Dictionary) -> void:
	self.score = dic.score
	self.total_leg = dic.total_leg
	self.total_set = dic.total_set
	self.double_in = dic.double_in
	self.double_out = dic.double_out
	self.show_check_out = dic.show_check_out
	
func exportDict() -> Dictionary:
	var dict: Dictionary = {
		'score' = self.score,
		'total_leg' = self.total_leg,
		'total_set' = self.total_set,
		'double_in' = self.double_in,
		'double_out' = self.double_out,
		'show_check_out' = self.show_check_out
	}
	return dict
	
