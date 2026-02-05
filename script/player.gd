extends CharacterBody2D

@export var speed := 150.0
@export var  file_dialog: DialogueResource


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
	# Kita cuma butuh cek tombol tekan di sini
	if Input.is_action_just_pressed("interact"):
		# Kalau player_near atau current_interactable ada, eksekusi
		if current_interactable:
			if current_interactable.has_method("interact"):
				current_interactable.interact()
			# Khusus untuk pintu yang pakai fungsi open_door
			elif current_interactable.has_method("open_door"):
				current_interactable.open_door()

# Fungsi untuk munculin icon (Dipanggil dari script pintu/objek)
func show_icon(lihat: bool):
	$InteractIcon.visible = lihat

# Sinyal Area (Opsional: Tetap pakai ini kalau mau simpan referensi objek)
func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("interactable"):
		current_interactable = area

func _on_interaction_area_area_exited(area: Area2D) -> void:
	if current_interactable == area:
		current_interactable = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		DialogueManager.show_example_dialogue_balloon(file_dialog, "start")
	
