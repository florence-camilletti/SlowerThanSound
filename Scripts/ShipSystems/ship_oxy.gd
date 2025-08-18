extends ShipSystemBase

@onready var Engine_lube_sprites    := [$ENG/L1, $ENG/L2, $ENG/L3, $ENG/L4, $ENG/L5]
@onready var Power_lube_sprites     := [$PWR/L1, $PWR/L2, $PWR/L3, $PWR/L4, $PWR/L5]
@onready var Target_lube_sprites    := [$TRG/L1, $TRG/L2, $TRG/L3, $TRG/L4, $TRG/L5]
@onready var AI_lube_sprites        := [$AI/L1, $AI/L2, $AI/L3, $AI/L4, $AI/L5]
@onready var Oxy_lube_sprites       := [$OXY/L1, $OXY/L2, $OXY/L3, $OXY/L4, $OXY/L5]
@onready var Bulk_lube_sprites      := [$BLK/L1, $BLK/L2, $BLK/L3, $BLK/L4, $BLK/L5]
@onready var Weap_lube_sprites      := [$WEP/L1, $WEP/L2, $WEP/L3, $WEP/L4, $WEP/L5]
@onready var LIDAR_lube_sprites     := [$LDR/L1, $LDR/L2, $LDR/L3, $LDR/L4, $LDR/L5]

@onready var all_lube_sprites := [
    null,
    Engine_lube_sprites,
    Power_lube_sprites,
    Target_lube_sprites,
    AI_lube_sprites,
    Oxy_lube_sprites,
    Bulk_lube_sprites,
    Weap_lube_sprites,
    LIDAR_lube_sprites
]

# === NODE VARS ===
@onready var Engine_coolant_sprites := [$ENG/C1, $ENG/C2, $ENG/C3, $ENG/C4, $ENG/C5]
@onready var Power_coolant_sprites  := [$PWR/C1, $PWR/C2, $PWR/C3, $PWR/C4, $PWR/C5]
@onready var Target_coolant_sprites := [$TRG/C1, $TRG/C2, $TRG/C3, $TRG/C4, $TRG/C5]
@onready var AI_coolant_sprites     := [$AI/C1, $AI/C2, $AI/C3, $AI/C4, $AI/C5]
@onready var Oxy_coolant_sprites    := [$OXY/C1, $OXY/C2, $OXY/C3, $OXY/C4, $OXY/C5]
@onready var Bulk_coolant_sprites   := [$BLK/C1, $BLK/C2, $BLK/C3, $BLK/C4, $BLK/C5]
@onready var Weap_coolant_sprites   := [$WEP/C1, $WEP/C2, $WEP/C3, $WEP/C4, $WEP/C5]
@onready var LIDAR_coolant_sprites  := [$LDR/C1, $LDR/C2, $LDR/C3, $LDR/C4, $LDR/C5]

@onready var all_coolant_sprites := [
    null,
    Engine_coolant_sprites,
    Power_coolant_sprites,
    Target_coolant_sprites,
    AI_coolant_sprites,
    Oxy_coolant_sprites,
    Bulk_coolant_sprites,
    Weap_coolant_sprites,
    LIDAR_coolant_sprites
]

# === SELECTION VARS ===
var system_list = [null, "Action_Q","Action_W","Action_E","Action_R",
                            "Action_A","Action_S","Action_D","Action_F"]
var selected_indx := 0

# === FLUID VARS ===
var lube_reserves := 200.0
var lube_regen := 0.1
var lube_cap := 100.0

var coolant_reserves := 100.0
var coolant_regen := 0.1
var coolant_cap := 100.0

#"MENU","ENGINE","POWER","OXY","AI","BULK","TARGET","WEAP","LIDAR"
var lube_levels := [0, 5, 5, 5, 5, 5, 5, 5, 5]
var lube_levels_max := [0, 5, 5, 5, 5, 5, 5, 5, 5]

var coolant_levels := [0, 5, 5, 5, 5, 5, 5, 5, 5]
var coolant_levels_max := [0, 5, 5, 5, 5, 5, 5, 5, 5]

func _init() -> void:
    super._init(false, Global.OXY)

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
        if(event.is_action_pressed("Action_I")):
            #Add lube
            self.lube_levels[self.selected_indx] = min(self.lube_levels[self.selected_indx]+1, self.lube_levels_max[self.selected_indx])
            update_all_sprites()
        if(event.is_action_pressed("Action_K")):
            #Remove lube
            self.lube_levels[self.selected_indx] = max(self.lube_levels[self.selected_indx]-1, 0)
            update_all_sprites()
        if(event.is_action_pressed("Action_O")):
            #Add coolant
            self.coolant_levels[self.selected_indx] = min(self.coolant_levels[self.selected_indx]+1, self.coolant_levels_max[self.selected_indx])
            update_all_sprites()
        if(event.is_action_pressed("Action_L")):
            #Remove coolant
            self.coolant_levels[self.selected_indx] = max(self.coolant_levels[self.selected_indx]-1, 0)
            update_all_sprites()

#Returns how much coolan/lube a system has
func get_indx_coolant(curr_indx: int) -> float:
    return((self.coolant_levels[curr_indx]+1.0)/(self.coolant_levels_max[curr_indx]+1.0))
func get_indx_lube(curr_indx: int) -> float:
    return((self.lube_levels[curr_indx]+1.0)/(self.lube_levels_max[curr_indx]+1.0))

#Update the sprites of all systems
func update_all_sprites() -> void:
    for n in range(1,len(self.all_lube_sprites)):
        update_lube_sprite(n)
        update_coolant_sprite(n)

#Update the sprites of a single system
func update_lube_sprite(curr_indx: int) -> void:
    var new_level = self.lube_levels[curr_indx]
    var sprites = self.all_lube_sprites[curr_indx]
    for level in range(len(sprites)):
        sprites[level].set_visible(new_level==level+1)
func update_coolant_sprite(curr_indx: int) -> void:
    var new_level = self.coolant_levels[curr_indx]
    var sprites = self.all_coolant_sprites[curr_indx]
    for level in range(len(sprites)):
        sprites[level].set_visible(new_level==level+1)
