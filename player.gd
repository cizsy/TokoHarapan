extends CharacterBody2D

@export var speed := 150.0

var last_dir := Vector2.DOWN

func _physics_process(_delta):
	var dir := Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1

	if dir != Vector2.ZERO:
		last_dir = dir
		velocity = dir.normalized() * speed
		play_walk_animation(dir)
	else:
		velocity = Vector2.ZERO
		play_idle_animation()

	move_and_slide()


func play_walk_animation(dir: Vector2):
	var anim := ""

	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			anim = "walkRight"
		else:
			anim = "walkLeft"
	else:
		if dir.y > 0:
			anim = "walkDown"
		else:
			anim = "walkUp"

	if $AnimatedSprite2D.animation != anim:
		$AnimatedSprite2D.play(anim)


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

	if $AnimatedSprite2D.animation != anim:
		$AnimatedSprite2D.play(anim)
var current_interactable = null

func _process(_delta):
	if current_interactable != null:
		$InteractIcon.visible = true
	else:
		$InteractIcon.visible = false

	if Input.is_action_just_pressed("interact"):
		if current_interactable:
			current_interactable.interact()
