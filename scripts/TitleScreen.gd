extends Node


func _ready() -> void:
    pass


func go_to_game() -> void:
    get_tree().change_scene_to_file("res://scenes/World.tscn")