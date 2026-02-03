extends Node2D


@onready var mask_scene = load("res://scenes/Mask.tscn")
@onready var timer = $Timer

var spawning_points = [0]
var bin_width := 200.0
var prev_spawn_half := 0


func _ready() -> void:
	timer.timeout.connect(spawn_and_restart)

	generate_spawning_points()

	reset_timer()
	timer.start()


func generate_spawning_points() -> void:
	for i in range(1, int(Global.arena_width_halved / bin_width)):
		spawning_points.append_array([i * bin_width, -i * bin_width])


func spawn_and_restart() -> void:
	if get_child_count() < Global.environment_mask_limit + 1:
		spawn()
	reset_timer()


func spawn() -> void:
	var new_mask = mask_scene.instantiate()
	var eligible_spawning_points = []

	if prev_spawn_half < 0:
		eligible_spawning_points = spawning_points.filter(func(x): return x > 0)
	elif prev_spawn_half > 0:
		eligible_spawning_points = spawning_points.filter(func(x): return x < 0)
	else:
		eligible_spawning_points = spawning_points.filter(func(x): return x == 0)
		randomize()
		prev_spawn_half = [-1, 1].pick_random()

	prev_spawn_half = -1 * prev_spawn_half

	randomize()
	new_mask.position.x = eligible_spawning_points.pick_random()
	# TODO maybe a more complex heuristic for mask ability?
	randomize()
	new_mask.ability = Global.ABILITIES.values().pick_random()

	add_child(new_mask)


func next_spawning_rule() -> Callable:
	if prev_spawn_half < 0:
		return (func(x): return x > 0)

	if prev_spawn_half > 0:
		return (func(x): return x < 0)

	return (func(x): return x == 0)


func reset_timer() -> void:
	timer.wait_time = 2.0
