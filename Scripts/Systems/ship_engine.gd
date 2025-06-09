extends ShipSystemBase

var statusNumsText
var inputNumsText

enum {NONE, HEADING, DEPTH, SPEED}
var setting_names = ["INPUT","Heading","Depth","Speed"]
var selected_setting: int

var input_num:int
var num_digits:int
var digits_left:int

func _ready() -> void:
    text_file_path = "res://Assets/Texts/Ship_Engine.txt"
    statusNumsText = $StatusNums
    inputNumsText = $InputNums
    
    selected_setting=NONE
    
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
            selected_setting = HEADING
            input_num=0
            digits_left=num_digits
        elif(event.is_action_pressed("J")):
            print("EMERGENCY HEADING")
            
        elif(event.is_action_pressed("I")):#Depth
            selected_setting = DEPTH
            input_num=0
            digits_left=num_digits
        elif(event.is_action_pressed("K")):
            print("EMERGENCY DIVE/SURFACE")
            
        elif(event.is_action_pressed("O")):#Speed
            selected_setting = SPEED
            input_num=0
            digits_left=num_digits
        elif(event.is_action_pressed("L")):
            print("EMERGENCY STOP/GO")
            
        #Check for number input
        if(selected_setting!=NONE):
            for n in range(10):
                if(event.is_action_pressed(str(n))):
                    input_num*=10
                    input_num+=n
                    digits_left-=1
                
                if(digits_left==0):
                    if(selected_setting==HEADING):
                        manager_node.heading = input_num
                    elif(selected_setting==DEPTH):
                        manager_node.depth = input_num
                    elif(selected_setting==SPEED):
                        manager_node.speed = input_num
                    input_num=0
                    digits_left=num_digits
                    selected_setting=NONE
            inputNumsText.set_text(setting_names[selected_setting]+"\n"+str(input_num))
                    
