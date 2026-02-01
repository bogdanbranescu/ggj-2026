extends Node


@onready var state_manager = $StateManager
@onready var timekeeper = $TimeKeeper


func _ready() -> void:
    EventBus.player_died.connect(game_over)

    timekeeper.start()

    await get_tree().create_timer(0.5).timeout
    # TODO fight setup
    $AnnouncerFIGHT.play()


func game_over(id: int) -> void:
    # TODO win panel
    print(id, " died!")
    state_manager.send_event("game_over")