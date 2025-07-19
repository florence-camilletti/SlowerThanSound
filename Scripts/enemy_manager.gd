extends Node2D

var manager_node
var rng = RandomNumberGenerator.new()
var timer: Timer

var enemy_chance := 0.5
var num_enemies := 0
var max_enemies := 3
var enemy_list := []
signal enemy_created

func _ready() -> void:
    self.timer = $EnemySpawn
    self.timer.timeout.connect(_on_timer_timeout)
    #self.timer.wait_time = 5
    self.timer.wait_time = 1
    self.timer.one_shot = false
    self.timer.start()
    
    self.manager_node = get_parent()

func _process(delta: float) -> void:
    pass

func _on_timer_timeout():
    if(self.num_enemies < self.max_enemies):
        if(rng.randf() < self.enemy_chance):
            make_new_enemy()

#Create a new enemy and update the manager
func make_new_enemy() -> void:
    var tmp_pos = Vector2(rng.randi_range(-300,300),rng.randi_range(-300,300))
    #var tmp_vel = Vector2(rng.randi_range(-1,1),rng.randi_range(-1,1))
    var tmp_vel = Vector2(0,0)
    self.num_enemies += 1
    var new_enemy = EnemyBase.new(num_enemies, "Cool Dude", tmp_pos, tmp_vel)
    #Add enemy to parent objects
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
