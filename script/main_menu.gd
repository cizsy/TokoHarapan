extends Control

func _on_newgame_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/rumah.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
