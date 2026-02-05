extends Node


var mask_scene_path = "res://scenes/Mask.tscn"
var projectile_scene_path = "res://scenes/Projectile.tscn"

var nodepath_environment = "/root/World/Environment"


const ABILITIES = {
    PUNCH = {
        name = "punch",
        uses = 3,
        time = 5.0,
        damage = 10.0,
        recovery = 1.0,
    },
    FIREBALL = {
        name = "fireball",
        uses = 3,
        time = 8.0,
        damage = 5.0,
        recovery = 0.1,
    },
    DASH = {
        name = "dash",
        uses = 1,
        time = 5.0,
        damage = 20.0,
        recovery = 1.0,
    },
    PARRY = {
        name = "parry",
        uses = 3,
        time = 5.0,
        damage = 10.0,
        recovery = 1.0,
    },
}

const LIMITED_MASK_USES := false
const LIMITED_MASK_TIME := true

const basic_attack_damage := 4.0
const basic_attack_recovery := 0.3

const environment_mask_limit := 1

const starting_hp := 100

const arena_width_halved := 1000
