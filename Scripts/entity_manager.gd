extends Node2D

# === NODE VARS ===
var manager_node: ShipManager
var rng = RandomNumberGenerator.new()
@onready var timer := $EnemySpawn

# === ENTITY VARS ===
signal entity_created
signal entity_destroyed
var entity_list := []

# === ENEMY VARS ===
var enemy_chance := 1.0
var num_enemies := 0
var max_enemies := 3

func _ready() -> void:
    self.timer.timeout.connect(_on_timer_timeout)
    
    self.manager_node = get_parent().get_parent().get_parent()

func _process(_delta: float) -> void:
    #If check collisions becomes too costly, this might be done
    # every few tics instead of every tic
    check_collisions()

func _on_timer_timeout() -> void:
    #Chance for a new enemy
    if(self.num_enemies < self.max_enemies):
        if(rng.randf() < self.enemy_chance):
            _make_new_enemy()

#Add ent to the manager's lists and connects it to the trees
func add_entity(ent: EntityBase) -> void:
    self.entity_list.append(ent)
    ent.death.connect(on_entity_death)
    add_child(ent)
    entity_created.emit(ent)
    
func add_enemy(enemy: BasicEnemy) -> void:
    add_entity(enemy)
func add_torpedo(torp: BasicTorp) -> void:
    add_entity(torp)
    
#When an entity signals their destruction, update and emit a signals
#and destroy the ent object
func on_entity_death(ent: EntityBase) -> void:
    var pos = entity_list.find(ent)
    entity_list.remove_at(pos)
    entity_destroyed.emit(ent)
    ent.queue_free()
    
#Create a new enemy and update the manager
func _make_new_enemy() -> void:#TESTING FUNCTION
    var tmp_pos = Vector2(rng.randi_range(-300,300),rng.randi_range(-300,300))
    tmp_pos += Global.map_middle
    #var tmp_vel = Vector2(rng.randf_range(-0.1,0.1),rng.randf_range(-0.1,0.1))
    var tmp_vel = Vector2(0,0)
    self.num_enemies += 1
    var new_enemy = BasicEnemy.new(num_enemies, tmp_pos, tmp_vel)#TODO: CHANGE THIS
    #Add enemy to parent objects
    add_entity(new_enemy)
    
func check_ent_id(curr_ent: String) -> bool:
    for e in entity_list:
        if(e.get_id()==curr_ent):
            return(true)
    return(false)
    
#Uses a spacial cell hash to determin if any torpedoes have collided with something
func check_collisions():
    var grid = {}
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
