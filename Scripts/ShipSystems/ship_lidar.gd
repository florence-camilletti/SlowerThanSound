extends ShipSystemBase

# === Map Vars ===
@onready var player_sprite := $PlayerSprite
var active_flag := true

# === Input Vars ===
@onready var inputBox := $TopMask/AutoInput
@onready var autoLightG := $TopMask/AutoLight/AutoLightG
@onready var autoBox := $TopMask/AutoBox
@onready var timer := $SweepTimer
var autoFlag := false
var autoRate: float
signal signal_update

# === Entity Vars ===
@onready var selected_sprite := $SelectionBox
signal entity_request
var selected_entity := "-1"

# === NOISE VARS ===
@onready var ping_noise := $LIDAR_Ping

func _init() -> void:
    super._init(false, Global.LIDAR)

func _ready() -> void:
    super._ready()

func _process(delta: float) -> void:
    super._process(delta)
    if(in_focus):
        pass
        
func _input(event: InputEvent) -> void:
    #Process player input
    if(in_focus):
        if(self.command_focus_open):
            if(event.is_action_pressed("Action_U")):
                #Set auto-update rate
                self.inputBox.clear()
                self.inputBox.grab_focus()
                self.request_command_focus.emit()
            if(event.is_action_pressed("Action_F")):
                self.active_flag = not self.active_flag

#Update the rotation of the player sprite    
func update_sub_rotation(deg) -> void:
    self.player_sprite.set_rotation_degrees(deg)
       
#Determines if an entity should be detected
func check_entity_detection(ent: EntityBase) -> bool:
    #TODO: FIll this out
    return(true)
    '''var curr_ent = curr_local_ent.ent_obj
    var final_detection: float
    if(is_active):
        final_detection = curr_ent.get_active_detection_level()
    else:
        final_detection = curr_ent.get_passive_detection_level()
    final_detection *= self.get_total_status()
    final_detection /= (manager_node.sub_position.distance_to(curr_ent.desec_pos))'''

func _on_timer_timeout() -> void:
    #Automatically refresh LIDAR
    entity_request.emit()
    ping_noise.play()

#Check the auto-LIDAR timer box
func _on_auto_input_text_changed(_new_text: String) -> void:
    #Check for only nums
    if(not self.inputBox.text.is_empty() and not self.inputBox.text.is_valid_float()):
        self.inputBox.clear()

#When auto-LIDAR timer box is submitted
func _on_auto_input_text_submitted(new_text: String) -> void:
    if(len(new_text)>0):
        self.autoRate = float(new_text)
        self.autoFlag = (autoRate!=0)
        self.autoLightG.set_visible(self.autoFlag)
        if(self.autoFlag):
            #Start timer
            self.timer.start(self.autoRate)
            self.autoBox.set_text(str(self.autoRate))
            self.signal_update.emit(true)
        else:
            #Stop timer
            self.timer.stop()
            self.autoBox.set_text("====")
            self.signal_update.emit(false)
                
    self.inputBox.clear()
    self.inputBox.release_focus()
