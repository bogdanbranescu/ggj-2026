extends Node2D


@onready var mask_scene = load("res://scenes/Mask.tscn")
@onready var timer = $Timer


var limits := [-1200.0, 1200.0]


func _ready() -> void:
	timer.timeout.connect(spawn_and_restart)

	reset_timer()
	timer.start()


func spawn_and_restart() -> void:
	spawn()
	reset_timer()


func spawn() -> void:
	var new_mask = mask_scene.instantiate()
	randomize()
	new_mask.position.x = randf_range(limits[0], limits[1])
	add_child(new_mask)


func reset_timer() -> void:
	timer.wait_time = 1.0
