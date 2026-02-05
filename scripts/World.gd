extends Node


@onready var state_manager = $StateManager
@onready var timekeeper = $TimeKeeper


func _ready() -> void:
	EventBus.player_died.connect(game_over)

	timekeeper.start()


func game_over(id: int) -> void:
	print(id, " died!")
	state_manager.send_event("game_over")


func _process(_delta: float) -> void:
	%Debug.text = str(%Camera.zoom, "\n", %Camera.position)


# func _input(event: InputEvent) -> void:
# 	print(event)
