extends RigidBody2D


@onready var collectable_area = $CollectableArea

var ability: Dictionary
var ability_animation_duration := 0.5

var mask_expiry_time := 6.0
var mask_use_count := 3


func _ready() -> void:
	collectable_area.area_entered.connect(apply_mask)


func set_ability() -> void:
	pass


func use_ability() -> void:
	print("USED ABILITY ", ability.name)


func _physics_process(_delta: float) -> void:
	pass


func apply_mask(area: Area2D) -> void:
	if area.name == "CollectionArea":
		area.get_parent().collect_mask(self )
		#area.get_parent().get_damage(25)
		#queue_free()
