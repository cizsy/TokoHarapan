extends Node2D

@export var npc: CharacterBody2D
@export var path_follow: PathFollow2D

@export var speed := 30.0
@export var stop_ratio := 0.5
@export var stop_time := 2.0
@export var auto_restart := true
@export var restart_delay := 1.0

var is_moving := false
var stop_triggered := false
var finished := false
var last_position := Vector2.ZERO

func _ready():
	if not npc or not path_follow:
		push_error("NPC atau PathFollow2D belum di-assign")
		set_physics_process(false)
		return
	
	path_follow.loop = false
	path_follow.rotates = false
	path_follow.progress_ratio = 0.0
	
	# set posisi awal
	npc.global_position = path_follow.global_position
	last_position = npc.global_position
	
	start_movement()

func start_movement():
	is_moving = true
	finished = false
	stop_triggered = false
	path_follow.progress_ratio = 0.0
	
	npc.global_position = path_follow.global_position
	last_position = npc.global_position

func _physics_process(delta):
	if not is_moving or finished:
		return
	
	path_follow.progress += speed * delta
	
	var current_pos = path_follow.global_position
	npc.global_position = current_pos
	
	_handle_animation(current_pos)
	
	# stop point
	if not stop_triggered and path_follow.progress_ratio >= stop_ratio:
		stop_triggered = true
		stop_and_look()
	
	# end path
	if path_follow.progress_ratio >= 1.0:
		finish_movement()

func _handle_animation(current_pos: Vector2):
	var dir = current_pos - last_position
	if dir.length() > 0.01 and npc.has_method("play_walk_animation"):
		npc.play_walk_animation(dir.normalized())
	last_position = current_pos

func stop_and_look():
	is_moving = false
	
	if npc.has_method("set_facing_direction"):
		npc.set_facing_direction(Vector2.RIGHT)
	elif npc.has_method("play_idle_animation"):
		npc.play_idle_animation()
	
	await get_tree().create_timer(stop_time).timeout
	
	if npc.has_method("set_facing_direction"):
		npc.set_facing_direction(Vector2.DOWN)
	
	is_moving = true

func finish_movement():
	finished = true
	is_moving = false
	
	if npc.has_method("play_idle_animation"):
		npc.play_idle_animation()
	
	if auto_restart:
		await get_tree().create_timer(restart_delay).timeout
		start_movement()
