extends Area2D

var player_near = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	print("Sesuatu masuk: ", body.name) # Debugging
	if body.name == "Player":   # pastikan sama dengan nama node playermu
		player_near = true
		print("Player terdeteksi!") # Debugging

func _on_body_exited(body):
	if body.name == "Player":
		player_near = false
		print("Player keluar area") # Debugging

func _process(delta):
	if player_near and Input.is_action_just_pressed("interact"):
		print("Tombol ditekan! OTW pindah...")
		open_door()

func open_door():
	get_tree().change_scene_to_file("res://toko.tscn")
	
	print("Pindah ke toko...")
	get_tree().change_scene_to_file("res://toko.tscn")
