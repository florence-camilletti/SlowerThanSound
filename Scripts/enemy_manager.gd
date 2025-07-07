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

#Create a new enemy and update the manager
func make_new_enemy() -> void:
    var tmp_pos = Vector2(0,0)
    var tmp_vel = Vector2(rng.randi_range(-300,300),rng.randi_range(-300,300))
    self.num_enemies += 1
    var new_enemy = EnemyBase.new(num_enemies, "Cool Dude", tmp_pos, tmp_vel)
    self.enemy_list.append(new_enemy)
    add_child(new_enemy)
    enemy_created.emit(self.num_enemies)
    
func get_num_enemies() -> int:
    return(self.num_enemies)
    
func get_enemy_list() -> Array:
    return(self.enemy_list)
    
#String info about the enemy
func _to_string() -> String:
    var rtn = ""
    for enemy in self.enemy_list:
        rtn+=str(enemy)+"\n"
    return(rtn)
