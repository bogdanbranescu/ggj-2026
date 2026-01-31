extends Node2D


@onready var hit_area = $HitArea


func _ready() -> void:
	hit_area.area_entered.connect(apply_hit)


func enable_detection(enable: bool) -> void:
	hit_area.monitoring = enable


func apply_hit(area: Area2D) -> void:
	print(self.get_tree().root)
	if area.name == "CollectionArea" and area.get_parent() != self.get_node("../.."): # Don't hit yourself!
		area.get_parent().get_damage(Global.basic_attack_damage)
