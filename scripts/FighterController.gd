extends CharacterBody2D


@onready var state = $StateChart


func _ready() -> void:
    pass


func _physics_process(delta: float) -> void:
    move(delta)


func move(_delta: float) -> void:
    # TODO movement
    pass


func use_masks() -> void:
    pass


func get_hit() -> void:
    pass
