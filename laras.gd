extends CharacterBody2D

@export var path_follow: PathFollow2D
@export var speed := 50.0

func _physics_process(delta):
	if path_follow == null:
		return

	path_follow.progress += speed * delta
	global_position = path_follow.global_position
