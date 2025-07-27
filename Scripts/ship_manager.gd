extends ShipSystemBase#THIS MAY NEED TO BE CHANGED BACK TO NODE2D IF IT GETS MESSY
class_name ShipManager

# === MENU VARS ===
var menu_choice: int;
enum {MENU,ENGINE,POWER,OXY,AI,BULK,TARGET,WEAP,LIDAR}#Manual controls
var actions := ["MENU","ENGINE","POWER","OXY","AI","BULK","TARGET","WEAP","LIDAR"]#Names of possible menu actions
var num_actions := len(actions)
var system_nodes := []#Child nodes belonging to each one
var focuses := []#Which one is currently being focused on

# === NODE VARS ===
var LIDAR_child: ShipSystemBase
var target_child: ShipSystemBase
var entity_manager: Node2D

# === MOVEMENT VARS ===
#Location details in long,lat
var sub_position := Vector2(0, 0)#Deciseconds; [-6,480,000 - 6,480,000, -3,240,000 - 3,240,000]
#Movement details
var heading := 0.0#Degrees; 0 - 360
var delta_heading := 0.0#Turn rate; deg/tick
var depth := 0.0#Meters; 0 - 240
var delta_depth := 0.0#Float/sink rate; meter/tick
var speed := 0.0#Desectics; 0 - 1/12
var delta_speed := 0.0#Acceleration; desectic/tick
var velocity := Vector2(0,0)

func _ready() -> void:
    self.LIDAR_child = $ShipLIDAR
    self.target_child = $ShipTarget
    self.entity_manager = $EntityManager
    self.LIDAR_child.entity_request.connect(on_LIDAR_request)
    self.target_child.new_selection.connect(on_new_selection)
    self.target_child.torpedo_launched.connect(on_torpedo_launch)
    self.entity_manager.entity_created.connect(on_entity_created)
    
    self.menu_choice = 0
    
    self.system_nodes = [$ShipMenu,
                    $ShipEngine,
                    $ShipPower,
                    $ShipOxy,
                    $ShipAI,
                    $ShipBulk,
                    $ShipTarget,
                    $ShipWeapons,
                    $ShipLIDAR]
    self.focuses = [true, false, false, false, false, false, false, false, false]

func _process(_delta: float):
    #Update ship position and speed
    self.heading+=delta_heading
    self.depth+=delta_depth
    self.speed+=delta_speed
    self.sub_position+=self.velocity
    self.LIDAR_child.update_sub_rotation(self.heading)
    
func _input(event):
    for possible_action in range(num_actions):#Check for menu change
        if(event.is_action_pressed(actions[possible_action])):
            self.menu_choice = possible_action#Set the menu choice
            for n in range(num_actions):#Set the focuses
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

#Update LIDAR's entity info
func on_LIDAR_request() -> void:
    var entity_list = self.entity_manager.get_entity_list()
    self.LIDAR_child.update_display(entity_list)
    self.LIDAR_child.request_flag = false

#When a new entity is selectedssss
func on_new_selection(id: String) -> void:
    self.LIDAR_child.update_selection(id)

func on_torpedo_launch(torpedo: BasicTorp) -> void:
    self.entity_manager.create_torpedo_launch(torpedo)

#When the entity managers signals a new entity has been made
func on_entity_created(ent: EntityBase) -> void:
    self.LIDAR_child.add_new_entity(ent)
    self.target_child.add_new_entity(ent)
