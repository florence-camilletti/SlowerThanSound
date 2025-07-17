extends ShipSystemBase

var statusNumsText
var inputNumsText
var inputBox

enum {NONE, SPEED, HEADING, DEPTH}
var setting_names = ["INPUT","Speed","Heading","Depth"]
var selected_setting: int

func _ready() -> void:
    statusNumsText = $StatusNums
    inputNumsText = $InputText
    inputBox = $InputBox
    
    selected_setting=NONE
    
    super._ready()
    
func _process(delta: float) -> void:
    super._process(delta)
    if(self.in_focus):
        #Update text
        statusNumsText.set_text(manager_node.get_sub_info())
    
func _input(event):
    #Process player input
    var input_flag = false
    if(in_focus):
        '''TODO Have changes be gradual
           instead of instant'''
        if(event.is_action_pressed("U")):#Speed
            selected_setting = SPEED
            input_flag = true
        elif(event.is_action_pressed("J")):
            #TODO
            print("EMERGENCY GO/STOP")
            
        elif(event.is_action_pressed("I")):#Heading
            selected_setting = HEADING
            input_flag = true
        elif(event.is_action_pressed("K")):
            #TODO
            print("EMERGENCY TURN")
            
        elif(event.is_action_pressed("O")):#Depth
            selected_setting = DEPTH
            input_flag = true
        elif(event.is_action_pressed("L")):
            #TODO
            print("EMERGENCY DIVE/SURFACE")
            
        #Check for number input
        if(input_flag):
            self.inputBox.grab_focus()
            
        if(event.is_action_pressed("Enter")):
            var inputNum = self.inputBox.get_text()
            self.inputBox.clear()
            self.inputBox.release_focus()
            
            if(selected_setting==HEADING):
                manager_node.heading = inputNum
            elif(selected_setting==DEPTH):
                manager_node.depth = inputNum
            elif(selected_setting==SPEED):
                manager_node.knot_speed = inputNum
                
        inputNumsText.set_text(setting_names[selected_setting])
                    
func _on_input_box_text_changed() -> void:
    #Check for only nums
    if(not self.inputBox.text.is_empty() and not self.inputBox.text.is_valid_int()):
        self.inputBox.clear()
