extends ShipSystemBase

# === NODE VARS ===
@onready var PowerStatusText := $PowerStatus
@onready var HeadingStatusText := $HeadingStatus
@onready var DepthStatusText := $DepthStatus

@onready var PowerInput := $PowerInput
@onready var HeadingInput := $HeadingInput
@onready var DepthInput := $DepthInput

@onready var inputBoxes := [null, PowerInput, HeadingInput, DepthInput]

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
        
func _input(event):
    #Process player input
    if(in_focus):
        if(event.is_action_pressed("Action_U")):#Engine power
            self.selected_setting = POWER
            self.PowerInput.grab_focus()
        elif(event.is_action_pressed("Action_J")):
            manager_node.emergency_speed()
            
        elif(event.is_action_pressed("Action_I")):#Heading
            self.selected_setting = HEADING
            self.HeadingInput.grab_focus()
        elif(event.is_action_pressed("Action_K")):
            manager_node.emergency_heading()
            
        elif(event.is_action_pressed("Action_O")):#Depth
            self.selected_setting = DEPTH
            self.DepthInput.grab_focus()
        elif(event.is_action_pressed("Action_L")):
            manager_node.emergency_depth()            
            
        if(event.is_action_pressed("Enter")):
            print(self.inputBoxes[self.selected_setting])
            var inputNum = float(self.inputBoxes[self.selected_setting].get_text())
            print(inputNum)
            for b in range(1, len(self.inputBoxes)):
                self.inputBoxes[b].clear()
                self.inputBoxes[b].release_focus()
            
            if(selected_setting==HEADING):
                manager_node.set_desire_heading(inputNum)
            elif(selected_setting==DEPTH):
                manager_node.set_desire_depth(inputNum)
            elif(selected_setting==POWER):
                manager_node.set_engine_power(inputNum)


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
