extends RigidBody2D


var ability: Global.ABILITIES


func set_ability() -> void:
    match ability:
        Global.ABILITIES.PUNCH:
            # TODO set art, behaviour, etc
            pass
        
        Global.ABILITIES.KICK:
            pass
        
        _:
            pass


func _physics_process(_delta: float) -> void:
    pass
