extends Control

@export var button01: TextureButton
@export var button02: TextureButton
@export var button03: TextureButton

var buttonList: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttonList = [button01, button02, button03]
