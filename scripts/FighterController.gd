extends CharacterBody2D


@export var gravity = 4000
@export var speed = 400

@onready var state = $StateChart

# Info
var id: int
var hp: int

# Movement
var direction := 0.0


func _ready() -> void:
	id = int(self.name.split("_")[-1])
	hp = Global.starting_hp


func _physics_process(delta: float) -> void:
	move(delta)

	velocity.x = direction * speed
	velocity.y += gravity * delta
	move_and_slide()


func move(_delta: float) -> void:
	direction = Input.get_axis(
		"left" + str(id),
		"right" + str(id),
	)
	

func use_masks() -> void:
	pass


func get_damage(damage_amount: int) -> void:
	hp = clamp(hp - damage_amount, 0, Global.starting_hp)

	if hp == 0:
		die()


func die() -> void:
	EventBus.player_died.emit(id)
