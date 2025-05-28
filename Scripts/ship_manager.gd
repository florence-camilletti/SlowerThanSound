extends Node2D

var menu_choice: int;

enum {MENU,ENGINE,POWER,OXY,AI,BULK,TARGET,WEAP,LIDAR}#Manual controls
var num_actions = 9
var actions = ["MENU","ENGINE","POWER","OXY","AI","BULK","TARGET","WEAP","LIDAR"]#Names of possible menu actions
var system_nodes = []#Child nodes belonging to each one
var focuses = []#Which one is currently being focused on

var ship_sprite

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

func _process(delta: float):
    for possible_action in range(num_actions):
        if(Input.is_action_just_pressed(actions[possible_action])):
            print(actions[possible_action])
            menu_choice = possible_action#Set the menu choice
            for n in range(num_actions):#Set the focuses
                if(possible_action==n):
                    system_nodes[n].set_focus(true)
                    focuses[n]=true
                else:
                    system_nodes[n].set_focus(false)        
                    focuses[n]=false
