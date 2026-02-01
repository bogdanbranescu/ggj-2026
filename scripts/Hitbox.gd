extends Node2D


@onready var hit_area = $HitArea


func _ready() -> void:
	hit_area.area_entered.connect(apply_hit)


func enable_detection(enable: bool) -> void:
	hit_area.monitoring = enable


func apply_hit(area: Area2D) -> void:
	var this_fighter = self.get_node("../..")
	var receiving_fighter = area.get_parent()

	if area.name == "CollectionArea" and this_fighter != receiving_fighter: # Don't hit yourself!
		var damage_direction = ((
			receiving_fighter.position.x - this_fighter.position.x) * Vector2.RIGHT
		).normalized()
		area.get_parent().take_damage(Global.basic_attack_damage, damage_direction)
