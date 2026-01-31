extends CharacterBody2D


@onready var state = $StateChart
@onready var masks = $MaskStack

# Info
var id: int
var hp: int

# Movement
@export var gravity = 4000
@export var speed = 400
var jump_force := 1500
var direction := 0.0


func _ready() -> void:
	id = int(self.name.split("_")[-1])
	hp = Global.starting_hp


func _physics_process(delta: float) -> void:
	var is_jump_available = is_on_floor()

	act(delta)
	move(delta)

	if Input.is_action_just_pressed("up" + str(id)): # and not has_died:
		if is_jump_available:
			jump(jump_force)
		# else:
		# 	is_jump_buffering = true
		# 	jump_buffer_timer.start()

	velocity.x = direction * speed
	velocity.y += gravity * delta
	
	move_and_slide()


func act(delta: float) -> void:
	if Input.is_action_pressed("action" + str(id)):
		if masks.get_child_count() == 0:
			attack_default()
		else:
			masks.use_abilities()


func attack_default() -> void:
	pass


func move(_delta: float) -> void:
	direction = Input.get_axis(
		"left" + str(id),
		"right" + str(id),
	)
	

func jump(force) -> void:
	velocity.y = - force
	# jump_hold_timer.start()
	# jump_buffer_timer.stop()

	$SoundJump.play() # TODO add jump sound


func collect_mask(mask: RigidBody2D) -> void:
	mask.call_deferred("reparent", self.masks)


func use_masks() -> void:
	pass


func get_damage(damage_amount: int) -> void:
	hp = clamp(hp - damage_amount, 0, Global.starting_hp)

	EventBus.player_damaged.emit(id, hp)

	if hp == 0:
		die()


func die() -> void:
	EventBus.player_died.emit(id)
