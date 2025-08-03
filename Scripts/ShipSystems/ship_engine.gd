extends ShipSystemBase

# === NODE VARS ===
@onready var statusNumsText := $StatusNums
@onready var inputNumsText := $InputText
@onready var inputBox := $InputBox

# === SETTING VARS ===
enum {NONE, SPEED, HEADING, DEPTH}
var setting_names = ["INPUT","Speed","Heading","Depth"]
var selected_setting := NONE

func _init() -> void:
    super._init(false, Global.ENGINE)

func _ready() -> void:    
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
        if(event.is_action_pressed("Action_U")):#Speed
            selected_setting = SPEED
            input_flag = true
        elif(event.is_action_pressed("Action_J")):
            #TODO
            manager_node.set_speed(0)
            
        elif(event.is_action_pressed("Action_I")):#Heading
            selected_setting = HEADING
            input_flag = true
        elif(event.is_action_pressed("Action_K")):
            #TODO
            manager_node.set_heading(0)
            
        elif(event.is_action_pressed("Action_O")):#Depth
            selected_setting = DEPTH
            input_flag = true
        elif(event.is_action_pressed("Action_L")):
            #TODO
            manager_node.set_depth(0)
            
        #Check for number input
        if(input_flag):
            self.inputBox.grab_focus()
            
        if(event.is_action_pressed("Enter")):
            var inputNum = float(self.inputBox.get_text())
            self.inputBox.clear()
            self.inputBox.release_focus()
            
            if(selected_setting==HEADING):
                manager_node.set_heading(inputNum)
            elif(selected_setting==DEPTH):
                manager_node.set_depth(inputNum)
            elif(selected_setting==SPEED):
                manager_node.set_speed(inputNum*Global.knot_desectic_ratio)
                
        inputNumsText.set_text(setting_names[selected_setting])
                    
func _on_input_box_text_changed(_new_text: String) -> void:
    #Check for only nums
    if(not self.inputBox.text.is_empty() and not self.inputBox.text.is_valid_int()):
        self.inputBox.clear()
