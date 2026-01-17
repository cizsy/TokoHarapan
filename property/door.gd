extends Area2D

var player_near = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_near = true
		# Panggil fungsi di player untuk munculkan icon
		if body.has_method("show_icon"):
			body.show_icon(true)

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_near = false
		# Panggil fungsi di player untuk sembunyikan icon
		if body.has_method("show_icon"):
			body.show_icon(false)

func _process(_delta):
	if player_near and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://toko.tscn")
