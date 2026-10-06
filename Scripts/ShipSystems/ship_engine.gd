extends ShipSystemBase

# === NODE VARS ===
@onready var PowerStatusText := $Power/PowerStatus
@onready var HeadingStatusText := $Heading/HeadingStatus
@onready var DepthStatusText := $Depth/DepthStatus

@onready var PowerInput := $Power/PowerInput
@onready var HeadingInput := $Heading/HeadingInput
@onready var DepthInput := $Depth/DepthInput

@onready var inputBoxes := [PowerInput, HeadingInput, DepthInput]

@onready var ENG_sprites := [$ENG/E1, $ENG/E2, $ENG/E3, $ENG/E4, $ENG/E5, $ENG/E6]
@onready var LDR_sprites := [$LDR/E1, $LDR/E2, $LDR/E3, $LDR/E4, $LDR/E5, $LDR/E6]
@onready var WEP_sprites := [$WEP/E1, $WEP/E2, $WEP/E3, $WEP/E4, $WEP/E5, $WEP/E6]
@onready var CPU_sprites := [$CPU/E1, $CPU/E2, $CPU/E3, $CPU/E4, $CPU/E5, $CPU/E6]
@onready var all_power_sprites := [
    null,
    ENG_sprites,
    LDR_sprites,
    WEP_sprites,
    CPU_sprites
]

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
@onready var ELC_noise := $ELC_Noise
@onready var engine_noise = $EngineNoise

# === SELECTION VARS ===
var system_list = [null, "Action_Q","Action_W","Action_E","Action_R"]
var selected_indx := 0
@onready var selection_sprite = $SelectedSystem
var x_offset := 580
var x_spacing := 350
var y_offset := 156
var y_spacing := 432

# === ELECTRICITY VARS ===
signal update_elec_amount
var elec_regen := 8
var elec_usage := 0.0
var elec_cap := 40000.0
var elec_reserves := self.elec_cap/2.0

#"MENU", "ENG", "LDR", "WEP", "CPU"
var elec_levels     := [0, 1, 1, 1, 1]
var elec_levels_max := [0, 6, 6, 6, 6]


func _init() -> void:
    super._init(false, Global.ENGINE)

func _ready() -> void:    
    super._ready()
    update_all_sprites()
    
func _process(delta: float) -> void:
    super._process(delta)
    self.elec_reserves-=self.elec_usage
    self.elec_reserves+=self.elec_regen
    self.elec_reserves = min(self.elec_reserves, self.elec_cap)
    
    var new_elec_amount = self.elec_reserves/self.elec_cap
    #self.elec_reserve_text.set_text("%.2f" % new_elec_amount)
    self.update_elec_amount.emit(new_elec_amount)
    if(new_elec_amount<=0):
        black_out()
        
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
        for action_indx in range(1, len(self.system_list)):
            if(event.is_action_pressed(self.system_list[action_indx])):
                self.selected_indx = action_indx
                self.selection_sprite.set_position(calc_dot_spot(self.selected_indx))
        if(event.is_action_pressed("Action_U")):
            #Add electricity
            self.elec_levels[self.selected_indx] = min(self.elec_levels[self.selected_indx]+1, self.elec_levels_max[self.selected_indx])
            update_all_sprites()
        if(event.is_action_pressed("Action_J")):
            #Remove electricity
            self.elec_levels[self.selected_indx] = max(self.elec_levels[self.selected_indx]-1, 0)
            update_all_sprites()
            
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

func get_indx_electricity(curr_indx: int) -> float:
    return((self.elec_levels[curr_indx]+1.0)/(self.elec_levels_max[curr_indx]+1.0))

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

#Calculates where the system selection dot should be on screen based on selected system
func calc_dot_spot(curr_indx: int) -> Vector2:
    if(curr_indx==-1):
        return(Vector2(-10,10))
        
    var x_val = int((curr_indx-1)%4)
    @warning_ignore("integer_division")
    var y_val = int((curr_indx-1)/4)
    x_val = x_offset + (x_val*x_spacing)
    y_val = y_offset + (y_val*y_spacing)
    return(Vector2(x_val,y_val))

#Updates the sprites for all systems
func update_all_sprites() -> void:
    ELC_noise.play()
    for n in range(1, len(self.all_power_sprites)):
        update_power_sprites(n)
    update_usage()
   
#Updates the sprites for a single system 
func update_power_sprites(curr_indx: int) -> void:
    var new_level = self.elec_levels[curr_indx]
    var sprites = self.all_power_sprites[curr_indx]
    for level in range(len(sprites)):
        sprites[level].set_visible(new_level==level+1)

#Called when power distribution is changed, calculates how much electricity is being used0
func update_usage() -> void:
    var total = 0
    for e in self.elec_levels:
        total+=e
    self.elec_usage = total

#Called when the sub runs out of power, all systems are set to 1
func black_out() -> void:
    self.elec_levels.fill(1)
    self.elec_levels[0] = 0
    update_all_sprites()
    update_usage()
