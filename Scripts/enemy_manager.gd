extends Node2D

var manager_node
var rng = RandomNumberGenerator.new()
var num_enemies: int
var max_enemies = 0
var enemy_list: Array

func _ready() -> void:
    manager_node = get_parent()
    num_enemies = 0
    enemy_list = []

func _process(delta: float) -> void:
    if(num_enemies < max_enemies):
        print("MAKING NEW ENEMY")
        make_new_enemy()

func make_new_enemy() -> void:
    pass
    
func get_pos() -> Vector2:
    return(enemy_list[0])
