extends Node2D

var menu_choice: int;
enum {MENU,ENGINE,POWER,OXY,AI,BULK,TARGET,WEAP,LIDAR}#Manual controls
var num_actions = 9
var actions = ["MENU","ENGINE","POWER","OXY","AI","BULK","TARGET","WEAP","LIDAR"]#Names of possible menu actions
var system_nodes = []#Child nodes belonging to each one
var focuses = []#Which one is currently being focused on

var ship_sprite

var heading: float
var delta_heading: float
var depth: float
var delta_depth: float
var speed: float
var delta_speed: float

func _ready() -> void:
    menu_choice = 0
    ship_sprite = $ShipSprite
    
    system_nodes = [$ShipMenu,
                    $ShipEngine,
                    $ShipPower,
                    $ShipOxy,
                    $ShipAI,
                    $ShipBulk,
                    $ShipTarget,
                    $ShipWeapons,
                    $ShipLIDAR]
    focuses = [true, false, false, false, false, false, false, false, false]
    
    heading=0
    depth=0
    speed=0
    delta_heading=0
    delta_depth=0
    delta_speed=0

func _process(delta: float):
    #Update ship position and speed
    heading+=delta_heading
    depth+=delta_depth
    speed+=delta_speed
    
    for possible_action in range(num_actions):#Check for menu change
        if(Input.is_action_just_pressed(actions[possible_action])):
            if(Input.is_action_pressed("Space")):
                menu_choice = possible_action#Set the menu choice
                for n in range(num_actions):#Set the focuses
                    if(possible_action==n):
                        system_nodes[n].set_focus(true)
                        focuses[n]=true
                    else:
                        system_nodes[n].set_focus(false)        
                        focuses[n]=false
