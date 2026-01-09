extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

# --- TAMBAHKAN INI ---
func _ready():
	rotation = 0
	velocity = Vector2.ZERO  # Gunakan velocity bawaan

func _physics_process(delta):
	# Velocity sudah diatur oleh Sutradara, langsung gerakkan
	move_and_slide()

# --- FUNGSI YANG SUDAH ADA ---
func atur_visual(arah_gerak: Vector2):
	rotation = 0
	if arah_gerak.x < -0.1:
		sprite.flip_h = true
	elif arah_gerak.x > 0.1:
		sprite.flip_h = false

	# --- TAMBAHKAN INI: ANIMASI BERJALAN/DIAM ---
	if arah_gerak.length() > 0.1:
		if sprite.animation != "jalan":  # Ganti "jalan" dengan nama animasimu
			sprite.play("jalan")
	else:
		if sprite.animation != "diam":  # Ganti "diam" dengan nama animasimu
			sprite.play("diam")
