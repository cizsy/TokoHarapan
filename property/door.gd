extends Area2D

var player_near = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	set_process(false)  # Nonaktifkan process dulu

func _on_body_entered(body):
	print("Sesuatu masuk: ", body.name)
	if body.name == "Player":   # pastikan sama dengan nama node playermu
		player_near = true
		set_process(true)  # Aktifkan process hanya saat player dekat
		print("Player terdeteksi!")

func _on_body_exited(body):
	if body.name == "Player":
		player_near = false
		set_process(false)  # Nonaktifkan process saat player keluar
		print("Player keluar area")

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		print("Tombol ditekan! OTW pindah...")
		open_door()

func open_door():
	print("Pindah ke toko...")
	# Hapus salah satu, cukup panggil sekali
	get_tree().change_scene_to_file("res://toko.tscn")
