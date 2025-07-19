extends Node2D

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
#1 nautical mile(nmile) = 1/60 degree = 1 minutes = 60 seconds = 600 decisecond
#1 degree = 36000 deciseconds
#1 knot = 1 nmile/hour = 600 decisecond/216000 ticks = 1 decisecond/360 ticks (1/360 dectic)
#1 decisecond = 3.09 meters
#1 tick = 1/60 second
var sub_position := Vector2(0, 0)#Deciseconds; [-6,480,000 - 6,480,000, -3,240,000 - 3,240,000]
#Movement details
var heading := 0.0#Degrees; 0 - 360
var delta_heading := 0.0#Turn rate; deg/tick
var depth := 0.0#Meters; 0 - 240
var delta_depth := 0.0#Float/sink rate; meter/tick
var knot_speed := 0.0#Knots; 0 - 30
var delta_knot_speed := 0.0#Acceleration; knot/tick

#1 knot = 1/360 decisecond/tick
var tick_translate = 360
#1 decisecond = 1/36000 degrees
var degree_translate = 36000

func _ready() -> void:
    self.LIDAR_child = $ShipLIDAR
    self.target_child = $ShipTarget
    self.enemy_manage_child = $EnemyManager
    self.LIDAR_child.enemy_request.connect(on_LIDAR_request)
    self.target_child.enemy_request.connect(on_target_list_request)
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
    self.sub_position+=knot_to_dectic(self.heading, self.knot_speed)
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
func knot_to_dectic(heading: float, speed: float) -> Vector2:
    #Translate heading (0-360 angle) into vector2 direction
    var x = sin(deg_to_rad(heading))
    var y = cos(deg_to_rad(heading))
    var direction_scale = Vector2(x, y)#Angle sub is pointing
    var new_vel = direction_scale * speed#knots
    new_vel /= tick_translate#knot -> d/t
    return(new_vel)

#Turns decisecond into decimal degrees
func deci_to_deg(d: Vector2) -> Vector2:
    var new_pos = d
    new_pos /= degree_translate
    return(new_pos)
    
#Turn decimal degrees into deciseconds
func deg_to_deci(d: Vector2) -> Vector2:
    var new_pos = d
    new_pos *= degree_translate
    return(new_pos)
     
#Returns a string about the sub's position and movement info
func get_sub_info() -> String:
    var rtn= str(deci_to_deg(self.sub_position)) + "\n"
    rtn += str(knot_speed) + "\n" + str(delta_knot_speed) + "\n"
    rtn += str(heading) + "\n" + str(delta_heading) + "\n"
    rtn += str(depth) + "\n" + str(delta_depth)
    return(rtn)

#Update LIDAR's enemy info
func on_LIDAR_request():
    var enemy_list = self.enemy_manage_child.get_enemy_list()
    self.LIDAR_child.update_display(enemy_list)
    self.LIDAR_child.request_flag = false
    
#Update targeting's enemy info
func on_target_list_request():
    var enemy_list = self.enemy_manage_child.get_enemy_list()
    self.target_child.update_list(enemy_list)

#When the enemy managers signals a new enemy has been made
func on_enemy_created(id: int) -> void:
    self.LIDAR_child.add_new_enemy(id)
