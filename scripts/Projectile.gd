extends Area2D


var direction := Vector2.ZERO
var damage := Global.ABILITIES.FIREBALL.damage


func _ready() -> void:
	area_entered.connect(_on_collision)


func _physics_process(delta: float) -> void:
	if direction == Vector2.ZERO:
		return

	position.x += delta * 200


func _on_collision(area: Area2D) -> void:
	if area.name == "CollectionArea":
		area.get_parent().take_damage(damage, direction)
