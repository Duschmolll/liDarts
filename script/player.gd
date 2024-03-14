class_name Player

var name: String
var flag: String
var dart_1: int = 0
var dart_2: int = 0
var dart_3: int = 0
var total_throw: int = 0
var turn: bool = false
var number_of_turn: int = 0
var total_score: int = 0
var target_score: int = 0
var leg: int = 0
var average: float = 0.0
var average_per_leg: float = 0.0

var target_score_label = Label
var history: VBoxContainer
var stat: VBoxContainer
var name_container: HBoxContainer 
var check_out_label: Label

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
