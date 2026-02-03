extends Camera2D


@onready var fighters = {
	1: get_node("../Fighter_1"),
	2: get_node("../Fighter_2"),
}

var zoom_base := 0.6
var winner_zoom := 3.0
var loser_zoom := 1.0
var initial_position := position

var is_showing_outro := false
var winner_id := 0
var loser_id := 0

var has_shown_loser := false


func _ready() -> void:
	EventBus.player_died.connect(func(id):
		is_showing_outro = true
		loser_id = id
		winner_id = 3 - id
	)
	zoom = zoom_base * Vector2.ONE


func _physics_process(delta: float) -> void:
	if is_showing_outro:
		if not has_shown_loser:
			show_loser(delta)
			return
		show_winner(delta)
		return

	var fighter_distance = fighters[1].position.x - fighters[2].position.x

	zoom = clamp(zoom_base + 150 / abs(fighter_distance), 0.85, 1.9) * Vector2.ONE

	position.x = (fighters[1].position.x + fighters[2].position.x) / 2
	position.y = clamp(initial_position.y, -300, 100) # initial_position.y + zoom.y * fighter_distance * 0.2


func show_loser(delta: float) -> void:
	position = position.move_toward(fighters[loser_id].position, 300 * delta)
	zoom = zoom.move_toward(loser_zoom * Vector2.ONE, 3.0 * delta)
	if position == fighters[loser_id].position and zoom == loser_zoom * Vector2.ONE:
		has_shown_loser = true


func show_winner(delta: float) -> void:
	position = position.move_toward(fighters[winner_id].position, 1000 * delta)
	zoom = zoom.move_toward(winner_zoom * Vector2.ONE, 3.0 * delta)
