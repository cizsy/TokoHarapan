extends Node2D

# Export variabel - ASSIGN DI INSPECTOR!
@export var npc: CharacterBody2D
@export var path: Path2D
@export var path_follow: PathFollow2D

@export var speed := 30.0
@export var stop_progress := 0.5
@export var stop_time := 2.0
@export var auto_restart := true
@export var restart_delay := 1.0

var is_moving := true
var stop_triggered := false
var finished := false
var last_position := Vector2.ZERO

func _ready():
	# DEBUG: Print status semua variabel
	print("=== NPC Controller Initialization ===")
	print("npc is null: ", npc == null)
	print("path is null: ", path == null)
	print("path_follow is null: ", path_follow == null)
	
	# Coba cari otomatis jika belum di-assign
	if not npc:
		try_find_npc()
	if not path:
		try_find_path()
	if not path_follow and path:
		try_find_path_follow()
	
	# Debug setelah pencarian
	print("After search - npc is null: ", npc == null)
	print("After search - path is null: ", path == null)
	print("After search - path_follow is null: ", path_follow == null)
	
	# Validasi
	if not npc:
		push_error("❌ NPC tidak ditemukan! Assign node Laras di inspector.")
		set_physics_process(false)
		return
	if not path:
		push_error("❌ Path tidak ditemukan! Assign node path_NPC di inspector.")
		set_physics_process(false)
		return
	if not path_follow:
		push_error("❌ PathFollow2D tidak ditemukan!")
		set_physics_process(false)
		return
	
	# Validasi curve
	if not path.curve:
		push_error("❌ Path tidak memiliki curve! Tambahkan curve di Path2D.")
		set_physics_process(false)
		return
	
	print("✅ Semua node ditemukan, curve valid")
	
	# Setup PathFollow2D
	path_follow.loop = false
	path_follow.rotates = false
	
	# Posisikan NPC di awal path
	var start_pos = path.curve.sample_baked(0)
	npc.global_position = path.to_global(start_pos)
	last_position = npc.global_position
	
	print("NPC start position: ", npc.global_position)
	
	# Mulai pergerakan
	start_movement()

func try_find_npc():
	print("Mencari NPC otomatis...")
	# Coba berbagai cara
	npc = get_node_or_null("../Laras") as CharacterBody2D
	if not npc:
		npc = get_parent().get_node("Laras") as CharacterBody2D
	if not npc:
		npc = get_tree().get_root().get_node("main_toko/Laras") as CharacterBody2D
	if not npc:
		# Cari berdasarkan tipe
		for child in get_tree().get_root().get_children():
			if child is CharacterBody2D and child.name == "Laras":
				npc = child
				break

func try_find_path():
	print("Mencari Path otomatis...")
	path = get_node_or_null("../path_NPC") as Path2D
	if not path:
		path = get_parent().get_node("path_NPC") as Path2D
	if not path:
		path = get_tree().get_root().get_node("main_toko/path_NPC") as Path2D

func try_find_path_follow():
	print("Mencari PathFollow2D otomatis...")
	if path:
		path_follow = path.get_node("PathFollow2D") as PathFollow2D

func start_movement():
	print("Memulai pergerakan NPC")
	is_moving = true
	stop_triggered = false
	finished = false
	path_follow.progress = 0
	
	# Reset posisi NPC
	if path.curve:
		var start_pos = path.curve.sample_baked(0)
		npc.global_position = path.to_global(start_pos)
		last_position = npc.global_position
		print("Reset NPC ke: ", npc.global_position)

func _physics_process(delta):
	if not is_moving or finished or not path or not path.curve:
		return
	
	# Debug progress
	print("Progress: ", path_follow.progress, " / ", path.curve.get_baked_length())
	
	# Update progress PathFollow2D
	path_follow.progress += speed * delta
	
	# Dapatkan posisi terkini
	var current_pos = path_follow.global_position
	
	# Gerakkan NPC visual
	npc.global_position = current_pos
	
	# Hitung arah pergerakan
	var move_dir = (current_pos - last_position).normalized()
	if move_dir.length() > 0.01:
		if npc.has_method("play_walk_animation"):
			npc.play_walk_animation(move_dir)
	
	last_position = current_pos
	
	# Cek akhir path
	if path_follow.progress_ratio >= 1.0:
		finish_movement()
		return
	
	# Cek titik berhenti
	if not stop_triggered and path_follow.progress_ratio >= stop_progress:
		print("🛑 Berhenti di progress: ", path_follow.progress_ratio)
		stop_triggered = true
		stop_and_look()

func stop_and_look():
	is_moving = false
	print("NPC berhenti dan melihat rak")
	
	if npc.has_method("set_facing_direction"):
		npc.set_facing_direction(Vector2.RIGHT)
	elif npc.has_method("play_idle_animation"):
		npc.play_idle_animation()
	
	await get_tree().create_timer(stop_time).timeout
	
	print("NPC melanjutkan perjalanan")
	if npc.has_method("set_facing_direction"):
		npc.set_facing_direction(Vector2.DOWN)
	
	is_moving = true

func finish_movement():
	finished = true
	is_moving = false
	print("🏁 NPC menyelesaikan perjalanan")
	
	if npc.has_method("play_idle_animation"):
		npc.play_idle_animation()
	
	if auto_restart:
		print("⏳ Menunggu ", restart_delay, " detik untuk restart...")
		await get_tree().create_timer(restart_delay).timeout
		start_movement()
