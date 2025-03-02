extends Control

#Control Group Nodes
@export var group00: Control
@export var group01: Control
@export var group02: Control
@export var group03: Control
@export var group04: Control
@export var group05: Control
@export var group06: Control
@export var group07: Control
@export var group08: Control
@export var group09: Control
@export var group10: Control
@export var group11: Control
@export var group12: Control
@export var group13: Control
@export var group14: Control
@export var group15: Control
@export var group16: Control
@export var group17: Control
@export var group18: Control
@export var group19: Control
@export var group20: Control

#Variables
var controlGroupList: Array[Control]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	controlGroupList.append(group00)
	controlGroupList.append(group01)
	controlGroupList.append(group02)
	controlGroupList.append(group03)
	controlGroupList.append(group04)
	controlGroupList.append(group05)
	controlGroupList.append(group06)
	controlGroupList.append(group07)
	controlGroupList.append(group08)
	controlGroupList.append(group09)
	controlGroupList.append(group10)
	controlGroupList.append(group11)
	controlGroupList.append(group12)
	controlGroupList.append(group13)
	controlGroupList.append(group14)
	controlGroupList.append(group15)
	controlGroupList.append(group16)
	controlGroupList.append(group17)
	controlGroupList.append(group18)
	controlGroupList.append(group19)
	controlGroupList.append(group20)
	
	for elem in controlGroupList:
		for btn in elem.get_children():
			if btn is TextureButton:
				if btn.texture_normal:
					# Get the image from the texture normal
					var image = btn.texture_normal.get_image()
					# Create the BitMap
					var bitmap = BitMap.new()
					# Fill it from the image alpha
					bitmap.create_from_image_alpha(image)
					# Assign it to the mask
					btn.texture_click_mask = bitmap
	pass
