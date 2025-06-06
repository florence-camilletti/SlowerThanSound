extends ShipSystemBase

var max_delta_heading = 2.0
var min_delta_heading = max_delta_heading*-1
var depth_change = 0.1

var max_delta_depth = 2.0
var min_delta_depth = max_delta_depth*-1
var delta_change = 0.1

var max_delta_speed = 2.0
var min_delta_speed = max_delta_speed*-1
var speed_change = 0.1

func _ready() -> void:
    text_file_path = "res://Assets/Texts/Ship_Engine.txt"
    super._ready()
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        if(Input.is_action_just_pressed("U")):#Heading
            if(Input.is_action_pressed("SHIFT")):#Auto-heading
                pass
            else:
                print("HEADING UP")
                var curr_delta = manager_node.delta_heading
                manager_node.delta_heading = min(curr_delta+depth_change, max_delta_heading)
        elif(Input.is_action_just_pressed("J")):
            print("HEADING DOWN")
            var curr_delta = manager_node.delta_heading
            manager_node.delta_heading = max(curr_delta-depth_change, min_delta_heading)
            
        elif(Input.is_action_just_pressed("I")):#Depth
            if(Input.is_action_pressed("SHIFT")):#Auto-depth
                pass
            else:
                print("DEPTH UP")
        elif(Input.is_action_just_pressed("K")):
            print("DEPTH DOWN")
            
        elif(Input.is_action_just_pressed("O")):#Speed
            if(Input.is_action_pressed("SHIFT")):#Auto-speed
                pass
            else:
                print("SPEED UP")
        elif(Input.is_action_just_pressed("L")):
            print("SPEED DOWN")
