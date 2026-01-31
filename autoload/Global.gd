extends Node


const ABILITIES = {
    PUNCH = {
        name = "punch",
        uses = 3,
        time = 10.0,
        damage = 10.0,
    },
    FIREBALL = {
        name = "fireball",
        uses = 3,
        time = 10.0,
        damage = 5.0,
    },
    DASH = {
        name = "dash",
        uses = 1,
        time = 8.0,
        damage = 15.0,
    },
    PARRY = {
        name = "parry",
        uses = 3,
        time = 10.0,
        damage = 10.0,
    },
}

const starting_hp := 100

const arena_width_halved := 1000
