extends Area2D


var direction := Vector2.ZERO
var speed := 2000
var damage
var wearer_ref: CharacterBody2D


func _ready() -> void:
	area_entered.connect(_on_collision)
	top_level = true
	if Global.ABILITIES.has("FIREBALL"):
		damage = Global.ABILITIES.FIREBALL.damage

	material.set_shader_parameter("fighter_id", wearer_ref.id)


func _physics_process(delta: float) -> void:
	if direction == Vector2.ZERO:
		return

	position.x += delta * speed * direction.x


func _on_collision(area: Area2D) -> void:
	if not Global.ABILITIES.has("FIREBALL"):
		return
	
	var mask_wearer_hurbox = wearer_ref.get_node("CollectionArea")
	if area.name == "CollectionArea" and area != mask_wearer_hurbox:
		area.get_parent().take_damage(damage, direction)
		$HitSound.play()
