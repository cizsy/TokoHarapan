extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
var last_dir := Vector2.DOWN

func _ready():
	# Nonaktifkan physics process karena NPC digerakkan oleh controller
	set_physics_process(false)

func play_walk_animation(dir: Vector2):
	if dir.length() > 0:
		last_dir = dir.normalized()
	
	var anim := ""
	if abs(last_dir.x) > abs(last_dir.y):
		if last_dir.x > 0:
			anim = "walkRight"
		else:
			anim = "walkLeft"
	else:
		if last_dir.y > 0:
			anim = "walkDown"
		else:
			anim = "walkUp"
	
	if sprite.animation != anim:
		sprite.play(anim)

func play_idle_animation():
	var anim := ""
	if abs(last_dir.x) > abs(last_dir.y):
		if last_dir.x > 0:
			anim = "idleRight"
		else:
			anim = "idleLeft"
	else:
		if last_dir.y > 0:
			anim = "idleDown"
		else:
			anim = "idleUp"
	
	if sprite.animation != anim:
		sprite.play(anim)

func set_facing_direction(dir: Vector2):
	last_dir = dir.normalized()
	play_idle_animation()

func interact ():
	print("NPC berinteraksi")
	
