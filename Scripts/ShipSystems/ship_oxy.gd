extends ShipSystemBase

# === NODE VARS ===

# === FLUID VARS ===
var fuel_systems := [Global.AI, Global.ENGINE, Global.WEAP]
var lube_systems := [Global.AI, Global.BULK, Global.ENGINE, Global.LIDAR, Global.WEAP]

var fuel_levels := [] #Fuel goes to AI, Engine, Weapons
var lube_levels := [] #Lubricant goes to AI, Bulkhead, Engine, LIDAR, Weapons

var fuel_max := [1, 2, 1]
var lube_max := [1, 1, 1, 1, 2]

func _ready() -> void:
    super._ready()
    
    fuel_levels.resize(len(fuel_systems))
    fuel_levels.fill(100)
    lube_levels.resize(len(lube_systems))
    lube_levels.fill(100)
    
func _process(delta: float) -> void:
    super._process(delta)
    if(in_focus):
        pass

func _input(event: InputEvent) -> void:
    if(event.is_action_pressed("Action_U")):
        #Add fuel
        pass
    if(event.is_action_pressed("Action_J")):
        #Remove fuel
        pass
    if(event.is_action_pressed("Action_I")):
        #Add lube
        pass
    if(event.is_action_pressed("Action_K")):
        #Remove lube
        pass
