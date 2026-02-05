extends Node

@onready var characters_left = %CharactersLeft
@onready var characters_right = %CharactersRight

var characters_left_init_position: Vector2
var characters_right_init_position: Vector2
var characters_amplitude := 500.0

var time := 0.0


func _ready() -> void:
    characters_left_init_position = characters_left.position
    characters_right_init_position = characters_right.position


func _process(delta: float) -> void:
    time += delta
    characters_left.position.y = characters_left_init_position.y + sin(time * 0.5) * characters_amplitude
    characters_right.position.y = characters_right_init_position.y - sin(time * 0.5) * characters_amplitude


func _input(_event: InputEvent):
    if Input.is_action_just_pressed("action1") or Input.is_action_just_pressed("action2"):
        go_to_game()


func go_to_game() -> void:
    get_tree().change_scene_to_file("res://scenes/World.tscn")