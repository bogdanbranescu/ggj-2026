extends RigidBody2D


@onready var projectile_scene = load(Global.projectile_scene_path)

@onready var collectable_area = $CollectableArea
@onready var collider = $Collider
@onready var sprite = $Sprite
@onready var timer = $Timer


var ability: Dictionary
var ability_animation_duration := 0.5
var uses_left: int


func _ready() -> void:
	collectable_area.area_entered.connect(apply_mask)
	timer.timeout.connect(expire)
	

func set_ability(mask_ability: Dictionary) -> void:
	await ready
	ability = mask_ability
	uses_left = ability.uses
	sprite.animation = "ability_" + ability.name
	timer.wait_time = ability.time


func use_ability() -> void:
	if uses_left == 0:
		return

	match ability.name:
		"punch": use_punch()
		"fireball": use_fireball()
		"dash": use_dash()
		"parry": use_parry()

	sprite.play("ability_" + ability.name)
	get_node("Sound/" + ability.name).play()
	
	uses_left -= 1
	if uses_left == 0:
		await sprite.animation_finished
		queue_free()


func use_punch():
	pass


func use_fireball():
	var fireball = projectile_scene.instantiate()
	fireball.direction
	

func use_dash():
	pass


func use_parry():
	pass


func _physics_process(_delta: float) -> void:
	pass


func enable_physics(enable: bool) -> void:
	sleeping = not enable
	freeze = not enable
	collider.disabled = not enable


func apply_mask(area: Area2D) -> void:
	if area.name == "CollectionArea":
		area.get_parent().collect_mask(self )
		call_deferred("enable_physics", false)
		timer.start()


func remove_mask() -> void:
	call_deferred("reparent", get_tree().root.find_child("MaskSpawner")) # TODO make this cleaner?
	call_deferred("enable_physics", true)


func expire() -> void:
	if sprite.is_playing():
		await sprite.animation_finished
		queue_free()
	else:
		queue_free()
