extends Node


@onready var state_chart := $StateChart as StateChart


func send_event(event: String) -> void:
    state_chart.send_event(event)


func _ready() -> void:
    state_chart.get_node("Mode/Main").state_entered.connect(_on_main_entered)
    state_chart.get_node("Mode/Outro").state_entered.connect(_on_outro_entered)


func _on_main_entered() -> void:
    print("FIGHT!!")
   # TODO handle music, player movement, masks


func _on_outro_entered() -> void:
    print("GAME OVER")
    get_tree().quit()
    # TODO handle music, player movement, masks, win panel
