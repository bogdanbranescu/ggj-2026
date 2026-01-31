extends CharacterBody2D


@onready var state = $StateChart
@onready var sprite = $Sprite
@onready var mask_holder = $MaskHolder
@onready var hitboxes = %Hitboxes


# Info
var id: int
var hp: int
var is_holding_mask: bool

# Movement
@export var gravity = 4000
@export var speed = 400
var jump_force := 1500
var direction := 0.0
var facing := 1.0

# Combat
var is_attacking := false


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
	
	if not is_attacking:
		update_facing()
		move_and_slide()
	
	update_animations()


func act(delta: float) -> void:
	if Input.is_action_just_pressed("action" + str(id)):
		if mask_holder.get_child_count() == 0:
			attack_default()
		else:
			mask_holder.get_child(0).use_ability()


func attack_default() -> void:
	is_attacking = true
	sprite.play("base_attack")
	await sprite.animation_finished
	is_attacking = false


func move(_delta: float) -> void:
	direction = Input.get_axis(
		"left" + str(id),
		"right" + str(id),
	)
	

func jump(force) -> void:
	velocity.y = - force
	# jump_hold_timer.start()
	# jump_buffer_timer.stop()

	$Sounds/Jump.play() # TODO add actual jump sound


func collect_mask(mask: RigidBody2D) -> void:
	if mask_holder.get_child_count() > 0:
		mask_holder.get_child(0).queue_free()
	mask.call_deferred("reparent", self.mask_holder)


func get_damage(damage_amount: int) -> void:
	hp = clamp(hp - damage_amount, 0, Global.starting_hp)

	EventBus.player_damaged.emit(id, hp)

	if hp == 0:
		die()


func die() -> void:
	EventBus.player_died.emit(id)


func update_animations():
	if is_attacking:
		return

	if is_on_floor():
		if direction == 0:
			sprite.play("idle")
		else:
			sprite.play("walk")
	else:
		if velocity.y < 0:
			sprite.play("jump")
		else:
			sprite.play("fall")


func update_facing():
	if direction != 0:
		facing = direction
		hitboxes.scale.x = direction
		sprite.flip_h = (direction == -1)
