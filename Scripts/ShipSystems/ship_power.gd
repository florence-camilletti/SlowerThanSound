extends ShipSystemBase

# === NODE VARS ===
@onready var inputBox := $SelectedSystem
@onready var AI_sprites := [$AI/P1, $AI/P2, $AI/P3, $AI/P4, $AI/P5, $AI/P6]
@onready var Bulk_sprites := [$Bulk/P1]
@onready var LIDAR_sprites := [$LIDAR/P1, $LIDAR/P2, $LIDAR/P3]
@onready var Oxy_sprites := [$Oxy/P1]
@onready var Target_sprites := [$Target/P1, $Target/P2, $Target/P3]
@onready var Weap_sprites := [$Weap/P1]


# === SELECTION VARS ===
var selected_system := 0
var selection_choices := [0,Global.AI, Global.BULK, Global.LIDAR, Global.OXY, Global.TARGET, Global.WEAP]

# === POWER VARS ===
var power_reserves = 1.0
var power_regen = 1.0
var power_cap = 1.0

#"MENU","ENGINE","POWER","OXY","AI","BULK","TARGET","WEAP","LIDAR"
var power_levels := [0, 0, 0, 1, 6, 1, 3, 1, 3]
var power_levels_max := [0, 0, 0, 1, 6, 1, 3, 1, 3]

func _init() -> void:
    super._init(false, Global.POWER)

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
            #Add power
            self.power_levels[self.selected_system] = min(self.power_levels[self.selected_system]+1, self.power_levels_max[self.selected_system])
            update_all_sprites()
        if(event.is_action_pressed("Action_J")):
            #Remove power
            self.power_levels[self.selected_system] = max(self.power_levels[self.selected_system]-1, 0)
            update_all_sprites()
        
        if(event.is_action_pressed("Enter")):
            var input = self.inputBox.get_text()
            if(input.is_valid_int()):
                var num_input = int(input)
                if(num_input>=1 and num_input<=6):
                    self.selected_system=self.selection_choices[num_input]
                
            self.inputBox.clear()
            self.inputBox.grab_focus()

func get_indx_power(curr_indx: int) -> float:
    return((self.power_levels[curr_indx]+1.0)/(self.power_levels_max[curr_indx]+1.0))

func update_all_sprites() -> void:
    #Update AI
    update_system_sprite(self.AI_sprites, Global.AI)
    update_system_sprite(self.Bulk_sprites, Global.BULK)
    update_system_sprite(self.LIDAR_sprites, Global.LIDAR)
    update_system_sprite(self.Oxy_sprites, Global.OXY)
    update_system_sprite(self.Target_sprites, Global.TARGET)
    update_system_sprite(self.Weap_sprites, Global.WEAP)
    
func update_system_sprite(sprites: Array, curr_indx: int) -> void:
    for level in range(len(sprites)):
        sprites[level].set_visible(self.power_levels[curr_indx]==level+1)

func _on_selected_system_text_changed(_new_text: String) -> void:
    #Check for only nums
    if(not self.inputBox.text.is_empty() and not self.inputBox.text.is_valid_int()):
        self.inputBox.clear()
