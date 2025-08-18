extends ShipSystemBase

# === NODE VARS ===
@onready var PowerStatusText := $Power/PowerStatus
@onready var HeadingStatusText := $Heading/HeadingStatus
@onready var DepthStatusText := $Depth/DepthStatus

@onready var PowerInput := $Power/PowerInput
@onready var HeadingInput := $Heading/HeadingInput
@onready var DepthInput := $Depth/DepthInput

@onready var inputBoxes := [null, PowerInput, HeadingInput, DepthInput]

# === DISPLAY VARS ===
var max_display_speed := 80
var speed_zero := Vector2(557, 727)
var speed_full := Vector2(557, 130)
var max_display_depth := 200
var depth_zero := Vector2(1755, 130)
var depth_full := Vector2(1755, 727)
@onready var currPower = $Power/CurrBar
@onready var requestHeading = $Heading/RequestBar
@onready var currHeading = $Heading/CurrBar
@onready var requestDepth = $Depth/RequestBar
@onready var currDepth = $Depth/CurrBar

# === SETTING VARS ===
enum {NONE, POWER, HEADING, DEPTH}
var selected_setting := NONE

func _init() -> void:
    super._init(false, Global.ENGINE)

func _ready() -> void:    
    super._ready()
    
func _process(delta: float) -> void:
    super._process(delta)
    if(self.in_focus):
        #Update text
        var engine_status = self.manager_node.get_engine_info()
        self.PowerStatusText.set_text("%.2f \t%.2f" % [engine_status[0], engine_status[1]])
        self.HeadingStatusText.set_text("%.2f" % [engine_status[2]])
        self.DepthStatusText.set_text("%.2f" % [engine_status[3]])
        
        #Update display vars
        #self.currPower.set_position(Vector2())
        var tmp = self.manager_node.get_engine_info()
        self.currPower.set_position(calc_speed_pos(tmp[0]))
        self.currHeading.set_rotation_degrees(tmp[2]+90)
        self.currDepth.set_position(calc_depth_pos(tmp[3]))
        
func _input(event):
    #Process player input
    if(in_focus):
        if(self.command_focus_open):
            if(event.is_action_pressed("Action_U")):#Engine power
                self.selected_setting = POWER
                self.PowerInput.grab_focus()
                request_command_focus.emit()
            elif(event.is_action_pressed("Action_J")):
                manager_node.emergency_speed()
                
            elif(event.is_action_pressed("Action_I")):#Heading
                self.selected_setting = HEADING
                self.HeadingInput.grab_focus()
                request_command_focus.emit()
            elif(event.is_action_pressed("Action_K")):
                manager_node.emergency_heading()
                
            elif(event.is_action_pressed("Action_O")):#Depth
                self.selected_setting = DEPTH
                self.DepthInput.grab_focus()
                request_command_focus.emit()
            elif(event.is_action_pressed("Action_L")):
                manager_node.emergency_depth()            
            
        if(event.is_action_pressed("Enter")):
            var text_input = self.inputBoxes[self.selected_setting].get_text()
            var good_input = len(text_input)>0
            var inputNum = float(text_input)
            for b in range(1, len(self.inputBoxes)):
                self.inputBoxes[b].clear()
                self.inputBoxes[b].release_focus()
            
            if(good_input):#Check to make sure something has been submitted
                if(selected_setting==HEADING):
                    manager_node.set_desire_heading(inputNum)
                    self.requestHeading.set_rotation_degrees(inputNum+90)
                elif(selected_setting==DEPTH):
                    manager_node.set_desire_depth(inputNum)
                    self.requestDepth.set_position(calc_depth_pos(inputNum))
                elif(selected_setting==POWER):
                    manager_node.set_engine_power(inputNum)

func calc_speed_pos(speed: float) -> Vector2:
    return(self.speed_zero.lerp(self.speed_full, speed/self.max_display_speed))
func calc_depth_pos(depth: float) -> Vector2:
    return(self.depth_zero.lerp(self.depth_full, depth/self.max_display_depth))

func _on_power_input_text_changed(_new_text: String) -> void:
    #Check for only nums
    if(not self.PowerInput.text.is_empty() and not self.PowerInput.text.is_valid_float()):
        self.PowerInput.clear()

func _on_heading_input_text_changed(_new_text: String) -> void:
    #Check for only nums
    if(not self.HeadingInput.text.is_empty() and not self.HeadingInput.text.is_valid_float()):
        self.HeadingInput.clear()

func _on_depth_input_text_changed(_new_text: String) -> void:
    #Check for only nums
    if(not self.DepthInput.text.is_empty() and not self.DepthInput.text.is_valid_float()):
        self.DepthInput.clear()
