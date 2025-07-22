extends Node2D

# === NODE VARS ===
var manager_node
var rng = RandomNumberGenerator.new()
var timer: Timer

# === ENTITY VARS ===
signal entity_created
var entity_list := []

# === ENEMY VARS ===
var enemy_chance := 1.0
var num_enemies := 0
var max_enemies := 3

func _ready() -> void:
    self.timer = $EnemySpawn
    self.timer.timeout.connect(_on_timer_timeout)
    #self.timer.wait_time = 5
    self.timer.wait_time = 1
    self.timer.one_shot = false
    self.timer.start()
    
    self.manager_node = get_parent()

func _process(_delta: float) -> void:
    pass

func _on_timer_timeout():
    #Chance for a new enemy
    if(self.num_enemies < self.max_enemies):
        if(rng.randf() < self.enemy_chance):
            make_new_enemy()

func create_entity(ent: EntityBase) -> void:
    self.entity_list.append(ent)
    add_child(ent)
    entity_created.emit(ent)
    
#Create a new enemy and update the manager
func make_new_enemy() -> void:
    var tmp_pos = Vector2(rng.randi_range(-300,300),rng.randi_range(-300,300))
    #var tmp_vel = Vector2(rng.randi_range(-1,1),rng.randi_range(-1,1))
    var tmp_vel = Vector2(0,0)
    self.num_enemies += 1
    var new_enemy = BasicEnemy.new(num_enemies, tmp_pos, tmp_vel)#TODO: CHANGE THIS
    #Add enemy to parent objects
    create_entity(new_enemy)
    
func create_torpedo_launch(torp: BasicTorp) -> void:
    create_entity(torp)
    
func get_num_entities() -> int:
    return(self.num_entities)
    
func get_entity_list() -> Array:
    return(self.entity_list)
    
#String info about the entity
func _to_string() -> String:
    var rtn = ""
    for entity in self.entity_list:
        rtn+=str(entity)+"\n"
    return(rtn)
