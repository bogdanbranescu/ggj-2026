extends RigidBody2D


@onready var projectile_scene = load(Global.projectile_scene_path)

@onready var collectable_area = $CollectableArea
@onready var collider = $Collider
@onready var sprite = $Sprite
@onready var hitbox = $Sprite/Hitbox
@onready var timer = $Timer

var ability: Dictionary
var ability_animation_duration := 0.5
var uses_left: int

var is_animating_depletion := false

var is_equiped := false

var time := 0.0
var cycle_direction: float


func _ready() -> void:
	collectable_area.area_entered.connect(apply_mask)
	hitbox.area_entered.connect(apply_hit)
	timer.timeout.connect(expire)

	hide()
	randomize()
	cycle_direction = float(randi() % 2 * 2 - 1)


func set_ability(mask_ability: Dictionary) -> void:
	await ready
	show()
	ability = mask_ability
	uses_left = ability.uses
	sprite.animation = "ability_" + ability.name
	timer.wait_time = ability.time

	enable_detection(false)


func use_ability() -> void:
	if uses_left == 0 and Global.LIMITED_MASK_USES:
		return

	match ability.name:
		"punch": use_punch()
		"fireball": use_fireball()
		"dash": use_dash()
		"parry": use_parry()

	sprite.play("ability_" + ability.name)
	get_node("Sound/" + ability.name).play()
	
	if not Global.LIMITED_MASK_USES:
		return

	uses_left -= 1
	if uses_left == 0:
		await sprite.animation_finished
		queue_free()


func use_punch() -> void:
	enable_detection(true)
	enable_detection(false)


func use_fireball() -> void:
	await get_tree().create_timer(0.1).timeout

	var fireball = projectile_scene.instantiate()
	var fighter = get_node("../../..") # messy :(
	fireball.wearer_ref = fighter
	fireball.direction = fighter.facing * Vector2.ONE
	fireball.position = self.global_position
	get_node(Global.nodepath_environment).add_child(fireball)
	

func use_dash() -> void:
	pass


func use_parry() -> void:
	# TODO implement parry
	pass


func _physics_process(delta: float) -> void:
	time += delta

	if not is_equiped:
		position.x = 750 * cos(cycle_direction * PI / 2 + time)
		position.y = 250 + 500 * sin(time) * cos(time)

	if timer.time_left > 0.0 and timer.time_left < 2.4 and not is_animating_depletion:
		print("here", self )
		animate_time_depletion()


func enable_physics(enable: bool) -> void:
	sleeping = not enable
	freeze = not enable
	collider.disabled = not enable


func apply_mask(area: Area2D) -> void:
	if is_equiped:
		return

	if area.name == "CollectionArea":
		var fighter = area.get_parent()
		if fighter.current_mask != null:
			return

		fighter.collect_mask(self )
		call_deferred("enable_physics", false)
		timer.start()
		is_equiped = true
	
		sprite.material.set_shader_parameter("fighter_id", fighter.id)


func remove_mask() -> void:
	call_deferred("reparent", get_tree().root.find_child("MaskSpawner")) # TODO make this cleaner?
	call_deferred("enable_physics", true)


func expire() -> void:
	if not Global.LIMITED_MASK_TIME:
		return
	
	if sprite.is_playing():
		await sprite.animation_finished
		queue_free()
	else:
		queue_free()


func animate_time_depletion() -> void:
	is_animating_depletion = true
	
	for i in range(3):
		hide()
		await get_tree().create_timer(0.4).timeout
		show()
		await get_tree().create_timer(0.4).timeout

	is_animating_depletion = false


func enable_detection(enable: bool) -> void:
	if ability.name == "fireball":
		return
		
	hitbox.get_node("Collider_" + ability.name).disabled = not enable


func apply_hit(area: Area2D) -> void:
	if not is_equiped:
		return

	var this_fighter = self.get_node("../../..") # TODO very bad, fix
	print("this", this_fighter)
	var receiving_fighter = area.get_parent()
	print("recv", receiving_fighter)
	if not "Fighter" in this_fighter.name:
		return


	if area.name == "CollectionArea" and this_fighter != receiving_fighter: # Don't hit yourself!
		var damage_direction = (this_fighter.facing * Vector2.RIGHT).normalized()
		area.get_parent().take_damage(Global.basic_attack_damage, damage_direction)
