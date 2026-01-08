extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D # Sesuaikan nama ini dengan nodemu

# Fungsi ini dipanggil oleh Script Sutradara di atas
func atur_visual(arah_gerak: Vector2):
	# Kalau gerak ke kiri (X negatif), balik gambarnya
	if arah_gerak.x < -0.1:
		sprite.flip_h = true
	# Kalau gerak ke kanan (X positif), jangan dibalik
	elif arah_gerak.x > 0.1:
		sprite.flip_h = false
