extends Control


@onready var hp_bar_1 = get_node("UIContainer/Bars/Player1/Value")
@onready var hp_bar_2 = get_node("UIContainer/Bars/Player2/Value")


func _ready() -> void:
    EventBus.player_damaged.connect(set_player_hp)

    set_player_hp(1, Global.starting_hp)
    set_player_hp(2, Global.starting_hp)


func set_player_hp(id: int, value: float) -> void:
    var hp_bar: ProgressBar
    
    if id == 1:
        hp_bar = hp_bar_1
    else:
        hp_bar = hp_bar_2
    
    hp_bar.value = value
