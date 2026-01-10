extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
var facing_direction := Vector2.DOWN

func atur_visual(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		facing_direction = Vector2(sign(dir.x), 0)
	else:
		facing_direction = Vector2(0, sign(dir.y))

	if facing_direction.x > 0:
		sprite.play("laras_right")
	elif facing_direction.x < 0:
		sprite.play("laras_left")
	elif facing_direction.y > 0:
		sprite.play("laras_down")
	else:
		sprite.play("laras_up")
