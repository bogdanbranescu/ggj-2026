extends CharacterBody2D


@onready var state = $StateChart
@onready var sprite = $Sprite
@onready var mask_holder = %MaskHolder
@onready var hitbox = %Hitbox


# Info
var id: int
var hp: int
var is_holding_mask: bool

# Movement
@export var gravity = 4000
@export var speed = 500
var jump_force := 1500
var direction := 0.0
var facing := 1.0

# Combat
var knockback_velocity: Vector2
var knockback_force := 2000
var knockback_decay := 10000

var is_attacking := false
var is_recovering := false
var is_hitstunned := false


func _ready() -> void:
	id = int(self.name.split("_")[-1])
	hp = Global.starting_hp

	sprite.material.set_shader_parameter("fighter_id", id)


func _physics_process(delta: float) -> void:
	print(is_attacking)
	var is_jump_available = is_on_floor()

	if not is_hitstunned:
		act(delta)
		move(delta)

		if Input.is_action_just_pressed("up" + str(id)): # and not has_died:
			if is_jump_available:
				jump(jump_force)

		velocity.x = direction * speed
		velocity.y += gravity * delta

		if is_attacking:
			velocity = Vector2.ZERO
	
	else:
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	
	
	if not (is_attacking or is_hitstunned):
		update_facing()
	
	move_and_slide()
	update_animations()


func act(_delta: float) -> void:
	if Input.is_action_just_pressed("action" + str(id)):
		if is_recovering:
			return

		if mask_holder.get_child_count() == 0:
			attack_default()
		else:
			mask_holder.get_child(0).use_ability()


func attack_default() -> void:
	is_attacking = true
	hitbox.enable_detection(true)
	sprite.play("base_attack")
	$Sounds/Punch.play()
	await sprite.animation_finished
	
	is_attacking = false
	hitbox.enable_detection(false)
	is_recovering = true

	await get_tree().create_timer(Global.basic_attack_recovery).timeout
	is_recovering = false


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


func take_damage(damage_amount: int, damage_direction: Vector2) -> void:
	hp = clamp(hp - damage_amount, 0, Global.starting_hp)
	
	is_hitstunned = true
	apply_knockback(damage_direction + Vector2.UP * 0.3, knockback_force)
	flash_damage(true)
	
	sprite.play("damaged")
	EventBus.player_damaged.emit(id, hp)
	await sprite.animation_finished

	is_hitstunned = false
	flash_damage(false)

	if hp == 0:
		die()


func apply_knockback(knockback_direction: Vector2, force: float) -> void:
	knockback_velocity = knockback_direction.normalized() * force
	sprite.flip_h = (knockback_direction.x > 0)


func flash_damage(enable: bool) -> void:
	var treshold_value

	if enable:
		treshold_value = 0.0;
	else:
		treshold_value = 1.0;
		
	sprite.material.set_shader_parameter("treshold", treshold_value)
		

func die() -> void:
	EventBus.player_died.emit(id)


func update_animations():
	if is_attacking or is_hitstunned:
		return

	if is_on_floor():
		if direction == 0:
			sprite.play("idle")
		else:
			sprite.play("walk")
			if !$Sounds/Steps.playing:
				$Sounds/Steps.play()
	else:
		if velocity.y < 0:
			sprite.play("jump")
		else:
			sprite.play("fall")


func update_facing():
	if direction != 0:
		facing = direction
		hitbox.scale.x = direction
		sprite.flip_h = (direction == -1)
