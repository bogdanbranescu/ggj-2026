extends RigidBody2D


@onready var collectable_area = $CollectableArea
@onready var collider = $Collider
@onready var sprite = $Sprite
@onready var timer = $Timer


var ability: Dictionary
var ability_animation_duration := 0.5


func _ready() -> void:
	collectable_area.area_entered.connect(apply_mask)
	timer.wait_time = ability.time
	

func set_ability(mask_ability: Dictionary) -> void:
	await ready
	ability = mask_ability
	sprite.animation = "ability_" + ability.name


func use_ability() -> void:
	sprite.play("ability_" + ability.name)
	get_node("Sound/" + ability.name).play()


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


func remove_mask() -> void:
	call_deferred("reparent", get_tree().root.find_child("MaskSpawner")) # TODO make this cleaner?
	call_deferred("enable_physics", true)


func expire() -> void:
	queue_free()
