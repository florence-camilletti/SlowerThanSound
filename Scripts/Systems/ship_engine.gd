extends ShipSystemBase

var statusNumsText

var heading_flag:bool
var depth_flag:bool
var speed_flag:bool

var input_num:int
var num_digits:int
var digits_left:int

func _ready() -> void:
    text_file_path = "res://Assets/Texts/Ship_Engine.txt"
    statusNumsText = $StatusNums
    
    heading_flag=false
    depth_flag=false
    speed_flag=false
    
    input_num=0
    num_digits=3
    digits_left=num_digits
    super._ready()
    
func _process(delta: float) -> void:
    super._process(delta)
    #Update text
    var txt_output = str(manager_node.heading) + "\n" + str(manager_node.delta_heading) + "\n"
    txt_output += str(manager_node.depth) + "\n" + str(manager_node.delta_depth) + "\n"
    txt_output += str(manager_node.speed) + "\n" + str(manager_node.delta_speed) + "\n"
    statusNumsText.set_text(txt_output)

func _input(event):
    #Process player input
    if(in_focus):
        if(event.is_action_pressed("U")):#Heading
            heading_flag = true
            input_num=0
            digits_left=num_digits
        elif(event.is_action_pressed("J")):
            print("EMERGENCY HEADING")
            
        elif(event.is_action_pressed("I")):#Depth
            depth_flag = true
            input_num=0
            digits_left=num_digits
        elif(event.is_action_pressed("K")):
            print("EMERGENCY DIVE/SURFACE")
            
        elif(event.is_action_pressed("O")):#Speed
            speed_flag = true
            input_num=0
            digits_left=num_digits
        elif(event.is_action_pressed("L")):
            print("EMERGENCY STOP/GO")
            
        #Check for number input
        if(heading_flag or depth_flag or speed_flag):
            for n in range(10):
                if(event.is_action_pressed(str(n))):
                    input_num*=10
                    input_num+=n
                    digits_left-=1
                
                if(digits_left==0):
                    if(heading_flag):
                        manager_node.heading = input_num
                    elif(depth_flag):
                        manager_node.depth = input_num
                    elif(speed_flag):
                        manager_node.speed = input_num
                    input_num=0
                    digits_left=num_digits
                    heading_flag = false
                    depth_flag = false
                    speed_flag = false
                    
