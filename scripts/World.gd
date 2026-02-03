extends Node


@onready var state_manager = $StateManager
@onready var timekeeper = $TimeKeeper


func _ready() -> void:
	EventBus.player_died.connect(game_over)

	timekeeper.start()

	EventBus.player_movement_disabled.emit()
	await get_tree().create_timer(0.7).timeout
	EventBus.player_movement_enabled.emit()

	# Fight setup
	# TODO camera flourish
	$AnnouncerFIGHT.play()


func game_over(id: int) -> void:
	# TODO winner camera flourish
	# TODO disable actions
	print(id, " died!")
	state_manager.send_event("game_over")
