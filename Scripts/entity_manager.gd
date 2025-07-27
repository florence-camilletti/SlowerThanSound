extends Node2D

# === NODE VARS ===
var manager_node
var rng = RandomNumberGenerator.new()
var timer: Timer
signal entity_destroyed

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
    check_collisions()

func _on_timer_timeout() -> void:
    #Chance for a new enemy
    if(self.num_enemies < self.max_enemies):
        if(rng.randf() < self.enemy_chance):
            make_new_enemy()

func on_entity_death(ent: EntityBase) -> void:
    print(str(ent)+" is D E A D")
    var pos = entity_list.find(ent)
    entity_list.remove_at(pos)
    entity_destroyed.emit(ent)

func create_entity(ent: EntityBase) -> void:
    self.entity_list.append(ent)
    ent.death.connect(on_entity_death)
    add_child(ent)
    entity_created.emit(ent)
    
#Create a new enemy and update the manager
func make_new_enemy() -> void:
    var tmp_pos = Vector2(rng.randi_range(-300,300),rng.randi_range(-300,300))
    tmp_pos += Global.map_middle
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

#TODO: Document
func check_collisions():
    var grid = {}
    var cell_size = 100#Desec
    #Create collision map
    for ent in entity_list:
        var cell_spot = ent.get_map_cell()
        if (not cell_spot in grid):
            grid[cell_spot] = []
        grid[cell_spot].append(ent)
        
    #Check for collisions
    for torp in entity_list:
        if(torp.is_torp()):#Only check for torpedoe collision
            var curr_pos = torp.get_desec_pos()
            var curr_cell_key = torp.get_map_cell()
            for x_range in range(-1, 2):#Check all neighboring cells
                for y_range in range(-1, 2):
                    var neighbor_key = curr_cell_key+Vector2(x_range,y_range)
                    if(neighbor_key in grid):
                        for target in grid[neighbor_key]:#For each neighboring entity, check distance
                            if(not target == torp):#Don't check itself, obviously
                                var hit = (curr_pos.distance_squared_to(target.get_desec_pos())) <= torp.get_kill_bubble_sqr()
                                if(hit):
                                    torp.set_health(0)
                                    target.damage(torp.get_damage_points())
