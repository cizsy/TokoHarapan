extends CharacterBody2D

@export var path_follow: PathFollow2D
@export var speed := 80.0

var last_dir := Vector2.DOWN

func _physics_process(delta:):
	if path_follow == null:
		return
	var prev_pos	:= global_position
	
# maju ke path
path_follow.progress += speed * delta
global_position =
path_follow.global_position

#arah gerak yang bener
var dir := global_position - prev_pos

if dir != Vector2.ZERO:
	last_dir = dir
	play walk
