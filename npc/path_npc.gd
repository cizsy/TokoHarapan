extends Path2D
# Script ini hanya untuk visual path (bisa di-hide di game)

func _ready():
	# Sembunyikan path di game (opsional)
	visible = false
	
	# Atau hanya sembunyikan line-nya
	if has_node("Line2D"):
		$Line2D.visible = false
