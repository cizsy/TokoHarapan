extends Area2D

func _on_body_entered(body):
	print("MASUK AREA", body.name)
	if body is CharacterBody2D:
		body.current_interactable = get_parent()

func _on_body_exited(body):
	print("KELUAR AREA", body.name)
	if body is CharacterBody2D:
		body.current_interactable = null
