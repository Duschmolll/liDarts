#class_name SaveInfo
#extends Resource
#
#const save_info_path := "user://saveinfo.tres"
#
#var test : Resource = "0"
#
#func _write_savefile() -> void:
	#ResourceSaver.save(save_info_path, self)
#
#func _load_savefile() -> void:
	#if ResourceLoader.exist(save_info_path, self):
		#return load(save_info_path)
	#return null
	#
#
