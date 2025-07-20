extends ShipSystemBase#THIS MAY NEED TO BE CHANGED BACK TO NODE2D IF IT GETS MESSY
class_name ShipManager

var menu_choice: int;
enum {MENU,ENGINE,POWER,OXY,AI,BULK,TARGET,WEAP,LIDAR}#Manual controls
var actions := ["MENU","ENGINE","POWER","OXY","AI","BULK","TARGET","WEAP","LIDAR"]#Names of possible menu actions
var num_actions := len(actions)
var system_nodes := []#Child nodes belonging to each one
var focuses := []#Which one is currently being focused on

var LIDAR_child: ShipSystemBase
var target_child: ShipSystemBase
var enemy_manage_child: Node2D

#Location details in long,lat
var sub_position := Vector2(0, 0)#Deciseconds; [-6,480,000 - 6,480,000, -3,240,000 - 3,240,000]
#Movement details
var heading := 0.0#Degrees; 0 - 360
var delta_heading := 0.0#Turn rate; deg/tick
var depth := 0.0#Meters; 0 - 240
var delta_depth := 0.0#Float/sink rate; meter/tick
var knot_speed := 0.0#Knots; 0 - 30
var delta_knot_speed := 0.0#Acceleration; knot/tick

func _ready() -> void:
    self.LIDAR_child = $ShipLIDAR
    self.target_child = $ShipTarget
    self.enemy_manage_child = $EnemyManager
    self.LIDAR_child.enemy_request.connect(on_LIDAR_request)
    self.target_child.enemy_request.connect(on_target_list_request)
    self.target_child.new_selection.connect(on_new_selection)
    self.enemy_manage_child.enemy_created.connect(on_enemy_created)
    
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

func _process(delta: float):
    #Update ship position and speed
    self.heading+=delta_heading
    self.depth+=delta_depth
    self.knot_speed+=delta_knot_speed
    self.sub_position+=(calculate_velocity(self.heading, self.knot_speed)*self.knot_desectic_ratio)
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

#Changes heading and speed into a vector2 of how much the sub has moved in 1 tick
func calculate_velocity(heading: float, speed: float) -> Vector2:
    #Translate heading (0-360 angle) into vector2 direction
    var x = sin(deg_to_rad(heading))
    var y = cos(deg_to_rad(heading))
    var direction_scale = Vector2(x, y)#Angle sub is pointing
    var new_vel = direction_scale * speed#knots
    return(new_vel)
     
#Returns a string about the sub's position and movement info
func get_sub_info() -> String:
    var rtn = str(self.sub_position*self.desec_deg_ratio) + "\n"
    rtn += str(knot_speed) + "\n" + str(delta_knot_speed) + "\n"
    rtn += str(heading) + "\n" + str(delta_heading) + "\n"
    rtn += str(depth) + "\n" + str(delta_depth)
    return(rtn)

#Update LIDAR's enemy info
func on_LIDAR_request() -> void:
    var enemy_list = self.enemy_manage_child.get_enemy_list()
    self.LIDAR_child.update_display(enemy_list)
    self.LIDAR_child.request_flag = false
    
#Update targeting's enemy info
func on_target_list_request() -> void:
    var enemy_list = self.enemy_manage_child.get_enemy_list()
    self.target_child.update_list(enemy_list)

func on_new_selection(id: int) -> void:
    self.LIDAR_child.update_selection(id)

#When the enemy managers signals a new enemy has been made
func on_enemy_created(id: int) -> void:
    self.LIDAR_child.add_new_enemy(id)
    self.target_child.add_new_enemy(id)
