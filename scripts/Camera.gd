extends Camera2D


@onready var fighter_1 = get_node("../Fighter_1")
@onready var fighter_2 = get_node("../Fighter_2")

var zoom_base := 0.6
var initial_position := position


func _ready() -> void:
	zoom = zoom_base * Vector2.ONE


func _physics_process(_delta: float) -> void:
	var fighter_distance = fighter_1.position.x - fighter_2.position.x

	zoom = clamp(zoom_base + 250 / abs(fighter_distance), 0.85, 1.9) * Vector2.ONE
	#print(zoom, fighter_1.position, fighter_2.position)

	
	#print(get_global_transform_with_canvas().get_origin())

	position.x = (fighter_1.position.x + fighter_2.position.x) / 2
	position.y = initial_position.y + zoom.y * fighter_distance * 0.1
