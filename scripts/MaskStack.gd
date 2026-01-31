extends Node2D


func use_abilities() -> void:
	var mask_count = get_child_count()
	for mask_id in range(mask_count - 1, -1, -1):
		var mask = get_child(mask_id).use_ability()
		await get_tree().create_timer(mask.ability_duration).timeout
