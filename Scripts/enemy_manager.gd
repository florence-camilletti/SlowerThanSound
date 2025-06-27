extends Node2D

var manager_node
var rng = RandomNumberGenerator.new()
var num_enemies: int
var max_enemies = 1
var enemy_list: Array

func _ready() -> void:
    self.manager_node = get_parent()
    self.num_enemies = 0
    self.enemy_list = []

func _process(delta: float) -> void:
    pass

func _input(event: InputEvent) -> void:
    if(event.is_action_pressed("U")):
        if(self.num_enemies < self.max_enemies):
            print("MAKING NEW ENEMY")
            make_new_enemy()

func make_new_enemy() -> void:
    print("Making enemy at spot 0, 0")
    self.num_enemies += 1
    
func get_pos() -> Vector2:
    return(self.enemy_list[0])
