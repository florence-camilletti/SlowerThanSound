extends Node2D

var manager_node
var rng = RandomNumberGenerator.new()
var num_enemies: int
var max_enemies = 5
var enemy_list: Array
signal enemy_created

func _ready() -> void:
    self.manager_node = get_parent()
    self.num_enemies = 0
    self.enemy_list = []

func _process(delta: float) -> void:
    pass

func _input(event: InputEvent) -> void:
    if(event.is_action_pressed("U")):
        if(self.num_enemies < self.max_enemies):
            make_new_enemy()

func make_new_enemy() -> void:
    var rnd_pos = Vector2(rng.randf_range(0, 0), rng.randf_range(0, 0))
    self.num_enemies += 1
    var new_enemy = EnemyBase.new(num_enemies, "Cool Dude", rnd_pos, Vector2(0, 100))
    print("Making enemy at spot "+str(rnd_pos))
    self.enemy_list.append(new_enemy)
    add_child(new_enemy)
    enemy_created.emit(self.num_enemies,Vector2(200,200))
    
func get_num_enemies() -> int:
    return(self.num_enemies)
    
func get_enemy_list() -> Array:
    return(self.enemy_list)
    
func _to_string() -> String:
    var rtn = ""
    for enemy in self.enemy_list:
        rtn+=str(enemy)+"\n"
    return(rtn)
