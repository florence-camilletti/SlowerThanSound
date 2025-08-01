extends ShipSystemBase

# === NODE VARS ===
var input_box: TextEdit
var AI_fuel := []
var AI_lube := []
var Bulk_lube := []
var Engine_fuel := []
var Engine_lube := []
var LIDAR_lube := []
var Weap_fuel := []
var Weap_lube := []

# === SELECTION VARS ===
var selected_system := 0
var selection_choices := [0,Global.AI, Global.BULK, Global.ENGINE, Global.LIDAR, Global.WEAP]

# === FLUID VARS ===
var fuel_reserves := 100.0
var lube_reserves := 200.0

var fuel_regen := 0.1
var lube_regen := 0.1

var fuel_cap := 100.0
var lube_cap := 100.0

#"MENU","ENGINE","POWER","OXY","AI","BULK","TARGET","WEAP","LIDAR"
var fuel_levels := [0, 3, 0, 0, 1, 0, 0, 2, 0] #Fuel goes to AI, Engine, Weapons
var lube_levels := [0, 2, 0, 0, 1, 2, 0, 2, 1] #Lubricant goes to AI, Bulkhead, Engine, LIDAR, Weapons

var fuel_max := [0, 3, 0, 0, 1, 0, 0, 2, 0]
var lube_max := [0, 2, 0, 0, 1, 2, 0, 2, 1]

func _ready() -> void:
    super._ready()
    self.input_box = $SelectedSystem
    self.AI_fuel = [$AIBars/F1]
    self.AI_lube = [$AIBars/L1]
    self.Bulk_lube = [$BulkBars/L1, $BulkBars/L2]
    self.Engine_fuel = [$EngineBars/F1, $EngineBars/F2, $EngineBars/F3]
    self.Engine_lube = [$EngineBars/L1, $EngineBars/L2]
    self.LIDAR_lube = [$LIDARBars/L1]
    self.Weap_fuel = [$WeapBars/F1, $WeapBars/F2]
    self.Weap_lube = [$WeapBars/L1, $WeapBars/L2]
    
func _process(delta: float) -> void:
    super._process(delta)
    if(in_focus):
        self.input_box.grab_focus()

func _input(event: InputEvent) -> void:
    if(self.in_focus):
        if(event.is_action_pressed("Action_U")):
            #Add fuel
            print("FUEL INC {0}".format(self.selection_choices[self.selected_system]))
        if(event.is_action_pressed("Action_J")):
            #Remove fuel
            print("FUEL DEC {0}".format(self.selection_choices[self.selected_system]))
        if(event.is_action_pressed("Action_I")):
            #Add lube
            print("LUBE INC {0}".format(self.selection_choices[self.selected_system]))
        if(event.is_action_pressed("Action_K")):
            #Remove lube
            print("LUBE DEC {0}".format(self.selection_choices[self.selected_system]))
            
        if(event.is_action_pressed("Enter")):
            self.input_box.release_focus()
            var input = self.input_box.get_text()
            if(input.is_valid_int()):
                var num_input = int(input)
                if(num_input>=1 and num_input<=5):
                    self.selected_system=num_input
                
            self.input_box.clear()
            self.input_box.grab_focus()
        
