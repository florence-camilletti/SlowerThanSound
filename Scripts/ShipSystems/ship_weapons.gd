extends ShipSystemBase

# === TORP VARS ===
signal torpedo_launched
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

# === TUBE VARS ===
@onready var tube_light = $TubeLight
@onready var tube_input = $TubeInput
@onready var current_tube_text = $CurrentTube
@onready var current_type_text = $CurrentType
var num_tubes := 4
var curr_tube := 1
var tube_open := [false, false, false, true]
var loaded_torps := [0, 1, 2, -1]

func _init() -> void:
    super._init(false, Global.WEAP)

func _ready() -> void:
    super._ready()
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
                if(self.tube_open[self.curr_tube]):
                    #Load torp
                    #Check if there's any of those torps left
                    if(self.torps_left[self.curr_torp_type]>0):
                        self.tube_open[self.curr_tube] = false
                        self.torps_left[self.curr_torp_type] -= 1
                        self.loaded_torps[self.curr_tube] = self.curr_torp_type
                        self.current_type_text.set_text(self.torp_names[self.curr_torp_type])
                else:
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
    var torp_object = self.torpedo_objects[self.loaded_torps[self.curr_tube]].new(self.next_torp_id)
    torp_object.set_target_id(self.target_system.get_selected_entity_ID())
    self.next_torp_id+=1
    
    #Launch the torp object
    torp_object.launch(self.manager_node.sub_position,
                        self.manager_node.heading,
                        self.manager_node.speed)
    torpedo_launched.emit(torp_object)
    #print(torp_object)
    
    #Clear tube
    self.tube_open[self.curr_tube] = true
    self.loaded_torps[self.curr_tube] = -1
    
func update_both_text() -> void:
    update_tube_text()
    update_torp_text()
func update_tube_text() -> void:
    self.current_tube_text.set_text(str(self.curr_tube+1))
    self.current_type_text.set_text(self.torp_names[self.loaded_torps[self.curr_tube]])
func update_torp_text() -> void:
    for t in range(4):
        self.torp_number_text[t].set_text(str(self.torps_left[t]))

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
