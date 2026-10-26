extends Node2D
class_name EntityManager

# === NODE VARS ===
var manager_node: ShipManager
var map_manager: MapManager
var LIDAR_node: ShipSystemBase
var rng = RandomNumberGenerator.new()
@onready var timer := $EnemySpawn

# === ENTITY VARS ===
var entity_list := []
@onready var selection_box := $SelectionBox
var select_flag := false
var selected_ent: EntityBase

# === ENEMY VARS ===
var enemy_chance := 1.0
var num_enemies := 0
var max_enemies := 3

func _ready() -> void:
    self.timer.timeout.connect(_on_timer_timeout)
    
    self.manager_node = self.find_parent_node()

func _process(_delta: float) -> void:
    #If check collisions becomes too costly, this might be done
    # every few tics instead of every tic
    check_ent_collisions()
    if(self.select_flag):
        self.selection_box.set_position(self.selected_ent.get_position())

func find_parent_node() -> ShipManager:
    var rtn = self
    while(rtn.get_parent()):
        rtn=rtn.get_parent()
        if(rtn is ShipManager):
            return(rtn)
    return(rtn)
    
func set_map_manager(m: MapManager) -> void:
    self.map_manager=m
func set_LIDAR_manager(m: ShipSystemBase) -> void:
    self.LIDAR_node=m
    self.LIDAR_node.entity_request.connect(on_LIDAR_request)

func _on_timer_timeout() -> void:
    #Chance for a new enemy
    if(self.num_enemies < self.max_enemies):
        if(rng.randf() < self.enemy_chance):
            #pass
            _make_new_still_enemy()
            #_make_new_moving_enemy()
            #_make_new_turning_enemy()

#Add ent to the manager's lists and connects it to the trees
func add_entity(ent: EntityBase) -> void:
    self.entity_list.append(ent)
    ent.death.connect(on_entity_death)
    ent.check_pos.connect(on_check_pos)
    add_child(ent)
    
func add_enemy(enemy: BasicEnemy) -> void:
    add_entity(enemy)
    
func add_torpedo(torp: BasicTorp) -> void:
    var target_id = torp.get_target_id()
    for ent in self.entity_list:#Set torpedo target
        if(ent.get_id() == target_id):
            torp.set_target(ent)
    add_entity(torp)
    '''self.entity_list.append(torp)
    torp.death.connect(on_entity_death)
    add_child(torp)
    entity_created.emit(torp)'''
    
    torp.launch(self.manager_node.sub_position, self.manager_node.heading, self.manager_node.speed)
    
#When an entity signals their destruction, update and emit a signals
#and destroy the ent object
func on_entity_death(ent: EntityBase) -> void:
    var pos = entity_list.find(ent)
    entity_list.remove_at(pos)
    ent.queue_free()
    
#When an entity is moving and needs to know if the next spot is valid
func on_check_pos(ent: EntityBase, pos: Vector2) -> void:
    var is_valid = not self.map_manager.check_collision(pos)
    ent.valid_next_pos = is_valid
    ent.pos_wait = false
    
func on_LIDAR_request() -> void:
    pass
    #TODO
    
func _make_new_still_enemy() -> void:
    var tmp_pos = Vector2(rng.randi_range(-60,60),rng.randi_range(-60,60))
    tmp_pos += Global.map_middle
    var tmp_vel = Vector2.ZERO
    self.num_enemies += 1
    var new_enemy = DumbEnemy.new(num_enemies, tmp_pos, tmp_vel)
    #Add enemy to parent objects
    self.add_entity(new_enemy)

#Create a new enemy and update the manager
func _make_new_moving_enemy() -> void:#TESTING FUNCTION
    var tmp_pos = Vector2(rng.randi_range(-200,200),rng.randi_range(-200,200))
    tmp_pos = Global.map_middle
    var tmp_vel = Vector2(rng.randf_range(-0.2,0.2),rng.randf_range(-0.2,0.2))
    self.num_enemies += 1
    var new_enemy = DumbEnemy.new(num_enemies, tmp_pos, tmp_vel)
    #Add enemy to parent objects
    self.add_entity(new_enemy)
    
func _make_new_turning_enemy() -> void:#TESTING FUNCTION
    var tmp_pos = Vector2(rng.randi_range(-300,300),rng.randi_range(-300,300))
    tmp_pos += Global.map_middle
    var tmp_vel = Vector2(rng.randf_range(0.1,0.3)*(2*(randi()%2)-1),rng.randf_range(0.1,0.3)*(2*(randi()%2)-1))
    self.num_enemies += 1
    var new_enemy = TurnEnemy.new(num_enemies, tmp_pos, tmp_vel)
    #Add enemy to parent objects
    self.add_entity(new_enemy)
    
#Uses a spacial cell hash to determin if any torpedoes have collided with something
func check_ent_collisions():
    var grid = {}
    #Create collision map
    for ent in entity_list:
        var cell_spot = ent.get_map_cell()
        if (not cell_spot in grid):
            grid[cell_spot] = []
        grid[cell_spot].append(ent)
        
    #Check for collisions
    for torp in entity_list:
        if(torp.is_torp() and torp.is_armed()):#Only check for armed torpedoe collision
            var curr_pos = torp.get_position()
            var curr_cell_key = torp.get_map_cell()
            for x_range in range(-1, 2):#Check all neighboring cells
                for y_range in range(-1, 2):
                    var neighbor_key = curr_cell_key+Vector2(x_range,y_range)
                    if(neighbor_key in grid):
                        for target in grid[neighbor_key]:#For each neighboring entity, check distance
                            if(not target == torp):#Don't check itself, obviously
                                var hit = (curr_pos.distance_squared_to(target.get_position())) <= torp.get_kill_bubble_sqr()
                                if(hit):
                                    torp.kill()
                                    target.damage(torp.get_damage_points())
    
#Try to select a new enemy and return if successful
func try_new_selection(ent_id: String) -> bool:
    for e in self.entity_list:
        if(e.get_id()==ent_id):
            self.selection_box.set_visible(true)
            self.selected_ent = e
            self.select_flag = true
            return(true)
    self.selection_box.set_visible(false)
    self.select_flag = false
    return(false)
                                   
#Returns if an entity exists with ID ent_id
func check_ent_id(ent_id: String) -> bool:
    for e in self.entity_list:
        if(e.get_id()==ent_id):
            return(true)
    return(false)
    
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
