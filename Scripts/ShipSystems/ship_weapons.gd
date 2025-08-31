extends ShipSystemBase

# === TORP VARS ===
enum {DUMB, HOMING, LOITER, WIRE}
var torp_names := ["DUMB", "HOMING", "LOITER", "WIRE", "EMPTY"]
var torps_left = [5, 5, 5, 5]
var curr_torp_type := 0
var next_torp_id := 1
@onready var torp_light = $TorpLight
@onready var torp_input = $TorpInput
@onready var torp_number_text = [$TorpNumbers/DumbNumber,
                                $TorpNumbers/HomingNumber,
                                $TorpNumbers/LoiterNumber,
                                $TorpNumbers/WireNumber]
var torpedo_objects = [DumbTorp, HomingTorp, LoiterTorp, WireTorp]
@onready var type_lights = [$TypeLights/DumbLight, $TypeLights/HomingLight, $TypeLights/LoiterLight, $TypeLights/WireLight]

# === TARGET VARS ===
@onready var LLF_text = [$LLFText/Lock,$LLFText/Load,$LLFText/Flood]
@onready var loading_text = $LLFText/Loading
@onready var flooding_text = $LLFText/Flooding
@onready var tube_target_text = [$TubeTargetNames/Tube1, $TubeTargetNames/Tube2, $TubeTargetNames/Tube3, $TubeTargetNames/Tube4]

# === TUBE VARS ===
@onready var tube_light = $TubeLight
@onready var tube_input = $TubeInput
@onready var current_tube_text = $CurrentTube
@onready var current_type_text = $CurrentType
var num_tubes := 4
var curr_tube := 0
var tube_lock_flag := [false, false, false, false]
var tube_open_flag := [true, true, true, true]
var tube_load_flag := [false, false, false, false]
var tube_flood_flag := [false, false, false, false]
var tube_targets := ["====","====","====","===="]
var loaded_torps := [-1, -1, -1, -1]

@onready var tube_load_timers := [$TubeLoadTimers/Tube1, $TubeLoadTimers/Tube2, $TubeLoadTimers/Tube3, $TubeLoadTimers/Tube4]
@onready var tube_flood_timers := [$TubeFloodTimers/Tube1, $TubeFloodTimers/Tube2, $TubeFloodTimers/Tube3, $TubeFloodTimers/Tube4]
var flood_time := 1.0#TODO: CHANGE THIS BACK

# === HUD SIGNALS ===
signal tube_locked
signal tube_loaded
signal tube_flooded
signal torpedo_launched

func _init() -> void:
    super._init(false, Global.WEAP)

func _ready() -> void:
    super._ready()
    for t in range(len(self.tube_load_timers)):
        self.tube_flood_timers[t].set_wait_time(self.flood_time)
    update_both_text()
    
func _input(event: InputEvent) -> void:
    if(self.in_focus):        
        if(self.command_focus_open):
            if(event.is_action_pressed("Action_J")):#Select torpedo tube
                self.tube_input.clear()
                self.tube_input.grab_focus()
                self.tube_light.set_visible(true)
                self.request_command_focus.emit()
            if(event.is_action_pressed("Action_K")):#Select torpedo type
                self.torp_input.clear()
                self.torp_input.grab_focus()
                self.torp_light.set_visible(true)
                self.request_command_focus.emit()
            if(event.is_action_pressed("Action_L")):#Load or launch
                if(self.tube_open_flag[self.curr_tube]):
                    #Load torp
                    #Check if there's any of those torps left
                    if(self.torps_left[self.curr_torp_type]>0):
                        #start load timer
                        self.torps_left[self.curr_torp_type] -= 1
                        self.tube_open_flag[self.curr_tube] = false
                        var load_time = Global.load_times[self.curr_torp_type] * (1.0/self.get_total_status())
                        self.tube_load_timers[self.curr_tube].set_wait_time(load_time)
                        self.tube_load_timers[self.curr_tube].start()
                        
                elif(self.tube_load_flag[self.curr_tube] and self.tube_flood_flag[self.curr_tube]):
                    #Fire torp
                    launch_torpedo()
                update_both_text()
                    
        if(event.is_action_pressed("Enter")):
            self.tube_light.set_visible(false)
            self.torp_light.set_visible(false)
            self.tube_input.release_focus()
            self.torp_input.release_focus()
    
func launch_torpedo() -> void:
    #Set up torpedo object
    var torpedo_type = self.loaded_torps[self.curr_tube]
    var torp_object = self.torpedo_objects[torpedo_type].new(self.next_torp_id)#TODO: DEBUG SOMEWHERE OVER HERE FOR TARGETING
    torp_object.set_target_id(self.tube_targets[self.curr_tube])
    self.next_torp_id+=1
    
    #Launch the torp object
    torpedo_launched.emit(self.curr_tube, torp_object)
    #print(torp_object)
    
    #Clear tube
    self.tube_open_flag[self.curr_tube] = true
    self.tube_lock_flag[self.curr_tube] = false
    self.tube_load_flag[self.curr_tube] = false
    self.tube_flood_flag[self.curr_tube] = false
    self.tube_targets[self.curr_tube] = "===="
    self.loaded_torps[self.curr_tube] = -1
    
    update_both_text()
    
func update_both_text() -> void:
    update_tube_text()
    update_torp_text()
func update_tube_text() -> void:
    self.current_tube_text.set_text(str(self.curr_tube+1))
    self.current_type_text.set_text(self.torp_names[self.loaded_torps[self.curr_tube]])
    for n in range(4):
        self.type_lights[n].set_visible(n==self.curr_torp_type)
        self.tube_target_text[n].set_text(self.tube_targets[n])
    self.LLF_text[0].set_visible(self.tube_lock_flag[self.curr_tube])
    self.LLF_text[1].set_visible(self.tube_load_flag[self.curr_tube])
    self.LLF_text[2].set_visible(self.tube_flood_flag[self.curr_tube])
    self.loading_text.set_visible(not self.tube_open_flag[self.curr_tube] and not self.tube_load_flag[self.curr_tube])
    self.flooding_text.set_visible(self.tube_load_flag[self.curr_tube] and not self.tube_flood_flag[self.curr_tube])
    
func update_torp_text() -> void:
    for t in range(4):
        self.torp_number_text[t].set_text(str(self.torps_left[t]))

#Tarteging has created a firing solution to the current tube, 
#Method called by ship_target
func give_tube_selection(ent_id: String) -> void:
    #Start load process
    self.tube_lock_flag[self.curr_tube] = true
    self.tube_targets[self.curr_tube] = ent_id
    update_both_text()
    tube_locked.emit(self.curr_tube)

func _on_tube_input_text_changed(new_text: String) -> void:
    if(new_text.is_valid_int()):
        var int_tube = int(new_text)
        if(int_tube >= 1 and int_tube <= self.num_tubes):
            self.curr_tube = int_tube-1
            update_tube_text()
    self.tube_input.clear()

func _on_torp_input_text_changed(new_text: String) -> void:
    if(new_text.is_valid_int()):
        var int_torp = int(new_text)
        if(int_torp >= 1 and int_torp <= len(self.torp_names)-1):
            self.curr_torp_type = int_torp-1
            update_tube_text()
    self.torp_input.clear()

#Called when the tube loading timer finishes
func load_tube(tube_num: int) -> void:
    self.tube_load_flag[tube_num] = true
    self.loaded_torps[tube_num] = self.curr_torp_type
    self.current_type_text.set_text(self.torp_names[self.curr_torp_type])
    update_both_text()
    tube_loaded.emit(tube_num)
    
    #Start flooding the tube
    self.tube_flood_timers[tube_num].set_wait_time(self.flood_time * (1.0/self.get_total_status()))
    self.tube_flood_timers[tube_num].start()

#Called when the tube flooding timer finishes
func flood_tube(tube_num: int) -> void:
    self.tube_flood_flag[tube_num] = true
    update_both_text()
    tube_flooded.emit(tube_num)
