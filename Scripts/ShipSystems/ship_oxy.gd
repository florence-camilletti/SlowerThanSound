extends ShipSystemBase

# === NODE VARS ===
@onready var inputBox := $SelectedSystem
@onready var AI_fuel_sprites := [$AIBars/F1]
@onready var AI_lube_sprites := [$AIBars/L1]
@onready var Bulk_lube_sprites := [$BulkBars/L1, $BulkBars/L2]
@onready var Engine_fuel_sprites := [$EngineBars/F1, $EngineBars/F2, $EngineBars/F3]
@onready var Engine_lube_sprites := [$EngineBars/L1, $EngineBars/L2]
@onready var LIDAR_lube_sprites := [$LIDARBars/L1]
@onready var Weap_fuel_sprites := [$WeapBars/F1, $WeapBars/F2]
@onready var Weap_lube_sprites := [$WeapBars/L1, $WeapBars/L2]

# === SELECTION VARS ===
var selected_system := 0
var selection_choices := [0,Global.AI, Global.BULK, Global.ENGINE, Global.LIDAR, Global.WEAP]

# === FLUID VARS ===
var fuel_reserves := 100.0
var fuel_regen := 0.1
var fuel_cap := 100.0

var lube_reserves := 200.0
var lube_regen := 0.1
var lube_cap := 100.0

#"MENU","ENGINE","POWER","OXY","AI","BULK","TARGET","WEAP","LIDAR"
var fuel_levels := [0, 3, 0, 0, 1, 0, 0, 2, 0] #Fuel goes to AI, Engine, Weapons
var fuel_levels_max := [0, 3, 0, 0, 1, 0, 0, 2, 0]

var lube_levels := [0, 2, 0, 0, 1, 2, 0, 2, 1] #Lubricant goes to AI, Bulkhead, Engine, LIDAR, Weapons
var lube_levels_max := [0, 2, 0, 0, 1, 2, 0, 2, 1]

func _init() -> void:
    super._init(false, Global.OXY)

func _ready() -> void:
    super._ready()    
    update_all_sprites()
    
func _process(delta: float) -> void:
    super._process(delta)
    if(in_focus):
        self.inputBox.grab_focus()

func _input(event: InputEvent) -> void:
    if(self.in_focus):
        if(event.is_action_pressed("Action_U")):
            #Add fuel
            self.fuel_levels[self.selected_system] = min(self.fuel_levels[self.selected_system]+1, self.fuel_levels_max[self.selected_system])
            update_all_sprites()
        if(event.is_action_pressed("Action_J")):
            #Remove fuel
            self.fuel_levels[self.selected_system] = max(self.fuel_levels[self.selected_system]-1, 0)
            update_all_sprites()
        if(event.is_action_pressed("Action_I")):
            #Add lube
            self.lube_levels[self.selected_system] = min(self.lube_levels[self.selected_system]+1, self.lube_levels_max[self.selected_system])
            update_all_sprites()
        if(event.is_action_pressed("Action_K")):
            #Remove lube
            self.lube_levels[self.selected_system] = max(self.lube_levels[self.selected_system]-1, 0)
            update_all_sprites()
            
        if(event.is_action_pressed("Enter")):
            var input = self.inputBox.get_text()
            if(input.is_valid_int()):
                var num_input = int(input)
                if(num_input>=1 and num_input<=5):
                    self.selected_system=self.selection_choices[num_input]
                
            self.inputBox.clear()
            self.inputBox.grab_focus()
        
#TODO: document
func update_all_sprites() -> void:
    #Update AI
    update_fuel_sprite(self.AI_fuel_sprites, Global.AI)
    update_lube_sprite(self.AI_lube_sprites, Global.AI)
    #Update Bulk
    update_lube_sprite(self.Bulk_lube_sprites, Global.BULK)
    #Update Engine
    update_fuel_sprite(self.Engine_fuel_sprites, Global.ENGINE)
    update_lube_sprite(self.Engine_lube_sprites, Global.ENGINE)
    #Update LIDAR
    update_lube_sprite(self.LIDAR_lube_sprites, Global.LIDAR)
    #Update Weap
    update_fuel_sprite(self.Weap_fuel_sprites, Global.WEAP)
    update_lube_sprite(self.Weap_lube_sprites, Global.WEAP)

func get_indx_fuel(curr_indx: int) -> float:
    return((self.fuel_levels[curr_indx]+1.0)/(self.fuel_levels_max[curr_indx]+1.0))
func get_indx_lube(curr_indx: int) -> float:
    return((self.lube_levels[curr_indx]+1.0)/(self.lube_levels_max[curr_indx]+1.0))

func update_fuel_sprite(sprites: Array, curr_indx: int) -> void:
    for level in range(len(sprites)):
        sprites[level].set_visible(self.fuel_levels[curr_indx]==level+1)
func update_lube_sprite(sprites: Array, curr_indx: int) -> void:
    for level in range(len(sprites)):
        sprites[level].set_visible(self.lube_levels[curr_indx]==level+1)

func _on_selected_system_text_changed(_new_text: String) -> void:
    #Check for only nums
    if(not self.inputBox.text.is_empty() and not self.inputBox.text.is_valid_int()):
        self.inputBox.clear()
