extends Path2D

@export var npc_scene: PackedScene
@export var speed := 20.0
@export var stop_progress := 0.5   # titik berhenti (0.0 - 1.0)
@export var stop_time := 2.0       # lama berhenti

@onready var pf := $PathFollow2D

var npc
var stopped := false
var stop_done := false

func _ready():
	pf.loop = false
	pf.rotates = false
	
	npc = npc_scene.instantiate()
	pf.add_child(npc)
	pf.progress_ratio = 0.0
	
func  _physics_process(delta) :
	if npc == null:
		return
	
	if not stopped:
		var before = npc.global_position
		pf.progress += speed * delta
		var after = npc.global_position
		
		var dir = after - before
		if dir.length() > 0.1:
			npc.atur_visual(dir)
			
	if not stop_done and pf.progress_ratio >= stop_progress:
		stop_done = true
		await berhenti_liat_rak()
		
func berhenti_liat_rak():
	stopped = true

	npc.facing_direction = Vector2.RIGHT
	npc.sprite.play("idle_right")

	await get_tree().create_timer(stop_time).timeout

	npc.facing_direction = Vector2.DOWN
	npc.sprite.play("idle_down")

	stopped = false
