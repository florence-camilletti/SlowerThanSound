extends Node2D

var rng = RandomNumberGenerator.new()
var num_enemies: int
var max_enemies = 1
var enemy_list: Array

func _ready() -> void:
    num_enemies = 0
    enemy_list = []

func _process(delta: float) -> void:
    if(num_enemies < max_enemies):
        print("MAKING NEW ENEMY")
        make_new_enemy()

func make_new_enemy() -> void:
    num_enemies+=1
    var rnd_x = rng.randf_range(-1, 1)
    var rnd_y = rng.randf_range(-1, 1)
    var enemy_pos = Vector2(rnd_x, rnd_y)
    #TODO: MAKE AN ENEMY OBJECT
    enemy_list.append(enemy_pos)
    print("ENEMY AT "+str(enemy_pos))
    
func get_pos() -> Vector2:
    return(enemy_list[0])
