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
signal update_lube_amount
signal update_coolant_amount
@onready var lube_reserve_text = $LubeReserve
@onready var lube_usage_text = $LubeUsage
@onready var coolant_reserve_text = $CoolantReserve
@onready var coolant_usage_text = $CoolantUsage

var lube_regen := 5
var lube_usage := 0.0
var lube_cap := 30000.0
var lube_reserves := self.lube_cap/2.0

var coolant_regen := 20
var coolant_usage := 0.0
var coolant_cap := 30000.0
var coolant_reserves := self.coolant_cap/2.0

#"MENU","ENGINE","POWER","OXY","AI","BULK","TARGET","WEAP","LIDAR"
var lube_levels     := [0, 1, 0, 0, 0, 1, 0, 2, 0]
var lube_levels_max := [0, 3, 0, 0, 0, 3, 0, 4, 0]

var coolant_levels     := [0, 2, 2, 2, 2, 2, 2, 2, 2]
var coolant_levels_max := [0, 5, 5, 5, 5, 5, 5, 5, 5]

func _init() -> void:
    super._init(false, Global.OXY)

func _ready() -> void:
    super._ready()
    update_all_sprites()
    
func _process(delta: float) -> void:
    super._process(delta)
    self.lube_reserves-=self.lube_usage
    self.lube_reserves+=self.lube_regen
    self.lube_reserves = min(self.lube_reserves, self.lube_cap)
    
    self.coolant_reserves-=self.coolant_usage
    self.coolant_reserves+=self.coolant_regen
    self.coolant_reserves = min(self.coolant_reserves, self.coolant_cap)
    
    var new_lube_amount = self.lube_reserves/self.lube_cap
    self.lube_reserve_text.set_text("%.2f" % new_lube_amount)
    self.update_lube_amount.emit(new_lube_amount)
    
    var new_coolant_amount = self.coolant_reserves/self.coolant_cap
    self.coolant_reserve_text.set_text("%.2f" % new_coolant_amount)
    self.update_coolant_amount.emit(new_coolant_amount)

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
    update_usage()

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
        
func update_usage() -> void:
    update_lube_usage()
    update_coolant_usage()

func update_lube_usage() -> void:
    var total = 0
    for e in self.lube_levels:
        total+=e
    self.lube_usage = total
    self.lube_usage_text.set_text(str(self.lube_usage) + "/" + str(self.lube_regen))
func update_coolant_usage() -> void:
    var total = 0
    for e in self.coolant_levels:
        total+=e
    self.coolant_usage = total
    self.coolant_usage_text.set_text(str(self.coolant_usage) + "/" + str(self.coolant_regen))
