extends Path2D

# --- BAGIAN SETTING ---
@export var npc_scene: PackedScene  # DIISI DI INSPECTOR!
@export var speed: float = 60.0
@export var exit_position: Vector2 = Vector2(100, 500)

# --- REFERENSI NODE ---
@onready var path_follow = $PathFollow2D
@onready var timer = $Timer

# --- STATUS PELANGGAN ---
enum State { KOSONG, BELANJA, BERHENTI, DI_KASIR, PULANG }
var current_state = State.KOSONG
var active_npc = null

func _ready():
	path_follow.loop = false
	timer.timeout.connect(_lanjut_jalan)
	
	# Tunggu sedikit agar scene siap
	await get_tree().create_timer(0.1).timeout
	spawn_pelanggan()

func spawn_pelanggan():
	if npc_scene == null:
		print("ERROR: Masukkan scene NPC di Inspector!")
		return
	
	var laras = npc_scene.instantiate()
	path_follow.add_child(laras)
	active_npc = laras
	path_follow.progress_ratio = 0.0
	current_state = State.BELANJA

func _physics_process(delta):
	if active_npc == null: 
		return

	var old_pos = active_npc.global_position

	match current_state:
		State.BELANJA:
			path_follow.progress += speed * delta
			
			if path_follow.progress_ratio >= 1.0:
				current_state = State.DI_KASIR
				print("Laras: Mas, mau bayar dong.")
			elif randf() < 0.005:
				current_state = State.BERHENTI
				timer.start(1.5)
		
		State.PULANG:
			# Pastikan NPC punya properti velocity
			if active_npc.has_method("set_velocity"):
				var arah = (exit_position - active_npc.global_position).normalized()
				active_npc.set_velocity(arah * speed)
			else:
				# Alternatif: gerakkan langsung
				var arah = (exit_position - active_npc.global_position).normalized()
				active_npc.position += arah * speed * delta
			
			if active_npc.global_position.distance_to(exit_position) < 10:
				active_npc.queue_free()
				active_npc = null
				current_state = State.KOSONG
	
	# Animasi
	var arah_gerak = active_npc.global_position - old_pos
	if active_npc and active_npc.has_method("atur_visual"):
		active_npc.atur_visual(arah_gerak)

func _lanjut_jalan():
	if current_state == State.BERHENTI:
		current_state = State.BELANJA

func _input(event):
	if event.is_action_pressed("ui_accept") and current_state == State.DI_KASIR:
		print("Transaksi Selesai! Laras Pulang.")
		
		var posisi_sekarang = active_npc.global_position
		path_follow.remove_child(active_npc)
		get_parent().add_child(active_npc)  # atau get_tree().current_scene
		
		active_npc.global_position = posisi_sekarang
		current_state = State.PULANG
