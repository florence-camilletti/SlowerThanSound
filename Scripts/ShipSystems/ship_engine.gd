extends ShipSystemBase

# === NODE VARS ===
@onready var PowerStatusText := $Power/PowerStatus
@onready var HeadingStatusText := $Heading/HeadingStatus
@onready var DepthStatusText := $Depth/DepthStatus

@onready var PowerInput := $Power/PowerInput
@onready var HeadingInput := $Heading/HeadingInput
@onready var DepthInput := $Depth/DepthInput

@onready var inputBoxes := [PowerInput, HeadingInput, DepthInput]

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

# === NOISE VARS ===
@onready var engine_noise = $EngineNoise

func _init() -> void:
    super._init(false, Global.ENGINE)

func _ready() -> void:    
    super._ready()
    
func _process(delta: float) -> void:
    super._process(delta)
    print(self.engine_noise.get_volume_linear())
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
                self.PowerInput.grab_focus()
                request_command_focus.emit()
            elif(event.is_action_pressed("Action_J")):
                manager_node.emergency_speed()
                
            elif(event.is_action_pressed("Action_I")):#Heading
                self.HeadingInput.grab_focus()
                request_command_focus.emit()
            elif(event.is_action_pressed("Action_K")):
                manager_node.emergency_heading()
                
            elif(event.is_action_pressed("Action_O")):#Depth
                self.DepthInput.grab_focus()
                request_command_focus.emit()
            elif(event.is_action_pressed("Action_L")):
                manager_node.emergency_depth()

func set_focus(f) -> void:
    self.engine_noise.set_pitch_scale(self.get_total_status())
    if(f):
        self.engine_noise.play()
    else:
        self.engine_noise.stop()
    super.set_focus(f)

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

func _on_power_input_text_submitted(new_text: String) -> void:
    if(len(new_text)>0):
        var inputNum = float(new_text)
        manager_node.set_engine_power(inputNum)
    self.inputBoxes[0].clear()
    self.inputBoxes[0].release_focus()

func _on_heading_input_text_submitted(new_text: String) -> void:
    if(len(new_text)>0):
        var inputNum = float(new_text)
        manager_node.set_desire_heading(inputNum)
        self.requestHeading.set_rotation_degrees(inputNum+90)
    self.inputBoxes[1].clear()
    self.inputBoxes[1].release_focus()

func _on_depth_input_text_submitted(new_text: String) -> void:
    if(len(new_text)>0):
        var inputNum = float(new_text)
        manager_node.set_desire_depth(inputNum)
        self.requestDepth.set_position(calc_depth_pos(inputNum))
    self.inputBoxes[2].clear()
    self.inputBoxes[2].release_focus()
