extends Node2D

var menu_choice: int;
enum {MENU,ENGINE,POWER,OXY,AI,BULK,TARGET,WEAP,LIDAR}#Manual controls
var actions = ["MENU","ENGINE","POWER","OXY","AI","BULK","TARGET","WEAP","LIDAR"]#Names of possible menu actions
var num_actions = len(actions)
var system_nodes = []#Child nodes belonging to each one
var focuses = []#Which one is currently being focused on

#Location details in long,lat
#1 nautical mile(nmile) = 1/60 degree = 1 minutes = 60 seconds = 600 decisecond
#1 knot = 1 nmile/hour = 600 decisecond/216000 ticks = 1 decisecond/360 ticks
#1 decisecond = 3.09 meters
#1 tick = 1/60 second
var sub_position: Vector2#Deciseconds; [-3,240,000 - 3,240,000, -6,480,000 - 6,480,000]
#Movement details
var heading: float#Degrees; 0 - 360
var delta_heading: float#Turn rate; deg/tick
var depth: float#Meters; 0 - 240
var delta_depth: float#Float/sink rate; meter/tick
var speed: float#Knots; 0 - 30
var delta_speed: float#Acceleration; knot/tick

#1 knot = 1/360 decisecond/tick
var tick_translate = 360
#1 decisecond = 1/36000 degrees
var degree_translate = 36000

func _ready() -> void:
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
    
    self.heading=0
    self.depth=0
    self.speed=0
    self.delta_heading=0
    self.delta_depth=0
    self.delta_speed=0

func _process(delta: float):
    #Update ship position and speed
    self.heading+=delta_heading
    self.depth+=delta_depth
    self.speed+=delta_speed
    self.sub_position+=knot_to_dectic(self.heading, self.speed)
    #print(translate_speed(self.heading, self.speed))
    
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
    rtn += str(heading) + "\n" + str(delta_heading) + "\n"
    rtn += str(depth) + "\n" + str(delta_depth) + "\n"
    rtn += str(speed) + "\n" + str(delta_speed)
    return(rtn)
