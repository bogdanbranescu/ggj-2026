extends Camera2D


@onready var fighter_1 = get_node("../Fighter_1")
@onready var fighter_2 = get_node("../Fighter_2")

var zoom_base := 0.1 * Vector2.ONE
var initial_position := position


func _ready() -> void:
	zoom = zoom_base


func _physics_process(_delta: float) -> void:
	var fighter_distance = fighter_1.position.x - fighter_2.position.x

	zoom = zoom_base + 150 / abs(fighter_distance) * Vector2.ONE
	#print(zoom, fighter_1.position, fighter_2.position)

	position.x = (fighter_1.position.x + fighter_2.position.x) / 2
	#position.y = initial_position.y - zoom.y * 10
