extends Area2D

var player_near = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_near = true
		print("Player masuk area")

func _on_body_exited(body):
	if body.name == "Player":
		player_near = false
		print("Player keluar area")

func _process(delta):
	if player_near and Input.is_action_just_pressed("interact"):
		print("Interact ditekan")
		open_door()

func open_door():
	print("PINDAH SCENE")
	get_tree().change_scene_to_file("res://rumah.tscn")
