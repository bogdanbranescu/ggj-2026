extends Node


@onready var state_manager = $StateManager
@onready var timekeeper = $TimeKeeper


func _ready() -> void:
    EventBus.player_died.connect(game_over)

    timekeeper.start()
    # TODO fight setup


func game_over(id: int) -> void:
    # TODO win panel
    print(id, " died!")
    state_manager.send_event("game_over")