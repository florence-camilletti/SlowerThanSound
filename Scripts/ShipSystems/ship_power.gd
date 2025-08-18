extends ShipSystemBase

# === NODE VARS ===
@onready var Eng_sprites    := [$ENG/E1, $ENG/E2, $ENG/E3, $ENG/E4, $ENG/E5, $ENG/E6]
@onready var Power_sprites  := [$PWR/E1, $PWR/E2, $PWR/E3, $PWR/E4, $PWR/E5, $PWR/E6]
@onready var Target_sprites := [$TRG/E1, $TRG/E2, $TRG/E3, $TRG/E4, $TRG/E5, $TRG/E6]
@onready var AI_sprites     := [$AI/E1, $AI/E2, $AI/E3, $AI/E4, $AI/E5, $AI/E6]
@onready var Oxy_sprites    := [$OXY/E1, $OXY/E2, $OXY/E3, $OXY/E4, $OXY/E5, $OXY/E6]
@onready var Bulk_sprites   := [$BLK/E1, $BLK/E2, $BLK/E3, $BLK/E4, $BLK/E5, $BLK/E6]
@onready var Weap_sprites   := [$WEP/E1, $WEP/E2, $WEP/E3, $WEP/E4, $WEP/E5, $WEP/E6]
@onready var LIDAR_sprites  := [$LDR/E1, $LDR/E2, $LDR/E3, $LDR/E4, $LDR/E5, $LDR/E6]

@onready var all_power_sprites := [
    null,
    Eng_sprites,
    Power_sprites,
    Target_sprites,
    AI_sprites,
    Oxy_sprites,
    Bulk_sprites,
    Weap_sprites,
    LIDAR_sprites
]

# === SELECTION VARS ===
var system_list = [null, "Action_Q","Action_W","Action_E","Action_R",
                            "Action_A","Action_S","Action_D","Action_F"]
var selected_indx := 0
@onready var selection_sprite = $SelectedSystem
var x_offset := 580
var x_spacing := 350
var y_offset := 156
var y_spacing := 432

# === ELECTRICITY VARS ===
var elec_reserves = 1.0
var elec_regen = 1.0
var elec_cap = 1.0

#"MENU","ENGINE","POWER","OXY","AI","BULK","TARGET","WEAP","LIDAR"
var elec_levels := [0, 6, 6, 6, 6, 6, 6, 6, 6]
var elec_levels_max := [0, 6, 6, 6, 6, 6, 6, 6, 6]

func _init() -> void:
    super._init(false, Global.POWER)

func _ready() -> void:
    super._ready()
    update_all_sprites()
    
func _process(delta: float) -> void:
    super._process(delta)

func _input(event: InputEvent) -> void:
    if(self.in_focus):
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

func get_indx_electricity(curr_indx: int) -> float:
    return((self.elec_levels[curr_indx]+1.0)/(self.elec_levels_max[curr_indx]+1.0))

func calc_dot_spot(curr_indx: int) -> Vector2:
    if(curr_indx==-1):
        return(Vector2(-10,10))
        
    var x_val = int((curr_indx-1)%4)
    @warning_ignore("integer_division")
    var y_val = int((curr_indx-1)/4)
    x_val = x_offset + (x_val*x_spacing)
    y_val = y_offset + (y_val*y_spacing)
    return(Vector2(x_val,y_val))

func update_all_sprites() -> void:
    for n in range(1, len(self.all_power_sprites)):
        update_power_sprites(n)
    
func update_power_sprites(curr_indx: int) -> void:
    var new_level = self.elec_levels[curr_indx]
    var sprites = self.all_power_sprites[curr_indx]
    for level in range(len(sprites)):
        sprites[level].set_visible(new_level==level+1)
