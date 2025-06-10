extends ShipSystemBase

var statusNumsText
var inputNumsText

enum {NONE, SPEED, HEADING, DEPTH, }
var setting_names = ["INPUT","Speed","Heading","Depth"]
var selected_setting: int

var input_num:int
var num_digits:int
var digits_left:int

func _ready() -> void:
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
    statusNumsText.set_text(manager_node.get_sub_info())

func _input(event):
    #Process player input
    if(in_focus):
        '''TODO Have changes be gradual
           instead of instant'''
        if(event.is_action_pressed("U")):#Speed
            selected_setting = SPEED
            input_num=0
            digits_left=num_digits
        elif(event.is_action_pressed("J")):
            #TODO
            print("EMERGENCY GO/STOP")
            
        elif(event.is_action_pressed("I")):#Heading
            selected_setting = HEADING
            input_num=0
            digits_left=num_digits
        elif(event.is_action_pressed("K")):
            #TODO
            print("EMERGENCY TURN")
            
        elif(event.is_action_pressed("O")):#Depth
            selected_setting = DEPTH
            input_num=0
            digits_left=num_digits
        elif(event.is_action_pressed("L")):
            #TODO
            print("EMERGENCY DIVE/SURFACE")
            
        #Check for number input
        if(selected_setting!=NONE):
            for n in range(10):
                if(event.is_action_pressed(str(n))):
                    input_num*=10
                    input_num+=n
                    digits_left-=1
                
                #Setting number if it's the 3rd digit
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
                    
