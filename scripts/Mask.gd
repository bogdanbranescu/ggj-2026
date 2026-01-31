extends RigidBody2D


@onready var collectable_area = $CollectableArea

var ability: Global.ABILITIES
var ability_duration := 0.5


func _ready() -> void:
	collectable_area.area_entered.connect(apply_mask)


func set_ability() -> void:
	match ability:
		Global.ABILITIES.PUNCH:
			# TODO set art, behaviour, etc
			pass
		
		Global.ABILITIES.KICK:
			pass
		
		_:
			pass


func use_ability() -> void:
	print("USED ABILITY", Global.ABILITIES.keys()[ability as Global.ABILITIES])


func _physics_process(_delta: float) -> void:
	pass


func apply_mask(area: Area2D) -> void:
	if area.name == "CollectionArea":
		area.get_parent().collect_mask(self )
		#area.get_parent().get_damage(25)
		#queue_free()
