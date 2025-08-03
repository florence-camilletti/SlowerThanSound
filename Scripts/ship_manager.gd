extends Node2D#THIS MAY NEED TO BE CHANGED BACK TO NODE2D IF IT GETS MESSY
class_name ShipManager

# === MENU VARS ===
@onready var system_nodes := [$VC/V/ShipMenu,#Child nodes belonging to each one
                    $VC/V/ShipEngine,
                    $VC/V/ShipPower,
                    $VC/V/ShipOxy,
                    $VC/V/ShipAI,
                    $VC/V/ShipBulk,
                    $VC/V/ShipTarget,
                    $VC/V/ShipWeapons,
                    $VC/V/ShipLIDAR]
var menu_choice := 0
var focuses := [true, false, false, false, false, false, false, false, false]#Which one is currently being focused on

# === NODE VARS ===
@onready var global_view := $VC/V
@onready var LIDAR_child := $VC/V/ShipLIDAR
@onready var oxy_child   := $VC/V/ShipOxy
@onready var power_child := $VC/V/ShipPower
@onready var target_child := $VC/V/ShipTarget
@onready var entity_manager := $VC/V/EntityManager

# === MOVEMENT VARS ===
#Location details in long,lat
var sub_position := Global.map_middle#Deciseconds; [0 - 720,000| 0 - 720,000]
var heading := 0.0#Degrees; 0 - 360
var delta_heading := 0.0#Turn rate; deg/tick
var depth := 0.0#Meters; 0 - 240
var delta_depth := 0.0#Float/sink rate; meter/tick
var speed := 0.0#Desectics; 0 - 1/12
var delta_speed := 0.0#Acceleration; desectic/tick
var velocity := Vector2(0,0)#Speed and direction

func _ready() -> void:
    self.LIDAR_child.entity_request.connect(on_LIDAR_request)
    self.target_child.new_selection.connect(on_new_selection)
    self.target_child.torpedo_launched.connect(on_torpedo_launch)
    self.entity_manager.entity_created.connect(on_entity_created)
    self.entity_manager.entity_destroyed.connect(on_entity_destroyed)

func _process(_delta: float):
    #Update ship position and speed
    self.heading+=delta_heading
    self.depth+=delta_depth
    self.speed+=delta_speed
    self.sub_position+=self.velocity
    #Update ship rotation
    self.LIDAR_child.update_sub_rotation(self.heading)
    
func _input(event):
    for possible_action in range(Global.num_systems):#Check for menu change
        if(event.is_action_pressed(Global.systems[possible_action])):
            self.menu_choice = possible_action#Set the menu choice
            for n in range(Global.num_systems):#Set the focuses
                if(possible_action==n):
                    self.system_nodes[n].set_focus(true)
                    self.focuses[n]=true
                else:
                    self.system_nodes[n].set_focus(false)        
                    self.focuses[n]=false
    
func _unhandled_input(event):#Quit on ESC
    if event is InputEventKey:
        if event.pressed and event.keycode == KEY_ESCAPE:
            get_tree().quit()
    
func set_heading(h: float) -> void:
    self.heading = h
    self.update_vel()
func set_depth(d: float) -> void:
    self.depth = d
func set_speed(s: float) -> void:
    self.speed = s
    self.update_vel()
func update_vel() -> void:
    self.velocity = Global.calc_desectic_vel(self.heading, self.speed)
    
#Returns a string about the sub's position and movement info
func get_sub_info() -> String:
    var rtn = str(self.sub_position*Global.desec_deg_ratio) + "\n"
    rtn += str(speed*Global.desectic_knot_ratio) + "\n" + str(delta_speed) + "\n"
    rtn += str(heading) + "\n" + str(delta_heading) + "\n"
    rtn += str(depth) + "\n" + str(delta_depth)
    return(rtn)
    
func get_viewport_object():
    return(self.global_view)
    
func get_fuel(indx: int) -> float:
    return(self.oxy_child.get_indx_fuel(indx))
func get_lube(indx: int) -> float:
    return(self.oxy_child.get_indx_lube(indx))
func get_power(indx: int) -> float:
    return(self.power_child.get_indx_power(indx))
    
#Update LIDAR's entity list from the entity manager
func on_LIDAR_request() -> void:
    var entity_list = self.entity_manager.get_entity_list()
    self.LIDAR_child.update_display(entity_list)
    self.LIDAR_child.request_flag = false

#When a new entity is selected, update LIDAR
#Signaled by Target
func on_new_selection(id: String) -> void:
    self.LIDAR_child.update_selection(id)

#When torpedo is launched, update Entity Manager
#Signaled by Target
func on_torpedo_launch(torpedo: BasicTorp) -> void:
    self.entity_manager.add_torpedo(torpedo)

#When ent has been created, update LIDAR and target
#Signaled by Entity Manager
func on_entity_created(ent: EntityBase) -> void:
    self.LIDAR_child.add_new_entity(ent)
    self.target_child.add_new_entity(ent)

#When ent had been destroyed, update LIDAR and target
#Signaled by Entity Manager
func on_entity_destroyed(ent: EntityBase) -> void:
    self.LIDAR_child.destroy_entity(ent)
    self.target_child.destroy_entity(ent)

func _to_string() -> String:
    return(get_sub_info())
