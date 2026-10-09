extends Node2D
class_name ShipSystemBase

# === META VARS ===
@onready var ElecLubeHeat = $ElecLubeHeat
var manager_node: ShipManager
var global_viewport: SubViewport
var in_focus: bool
var system_indx: int
var sibling_flag := false

# === THE TALKING STICK ===
@warning_ignore("unused_signal")
signal request_command_focus
@warning_ignore("unused_signal")
signal return_command_focus
var command_focus_open: bool

# === SIBLING VARS ===
var menu_system: ShipSystemBase
var engine_system: ShipSystemBase
var LIDAR_system: ShipSystemBase
var weapons_system: ShipSystemBase
var CPU_system: ShipSystemBase
var all_systems: Array

# === STATUS VARS ===
var health := 1.0
var electricity := 1.0
var total_status := 1.0

func _init(f:bool, i:int) -> void:
    self.in_focus=f
    self.system_indx=i

func _ready() -> void:
    self.manager_node = self.find_parent_node()
        
    self.global_viewport = self.get_viewport()
    in_focus = false
    self.visible = false
    
func _process(_delta: float) -> void:
    update_ELC()

func find_parent_node() -> ShipManager:
    var rtn = self
    while(rtn.get_parent()):
        rtn=rtn.get_parent()
        if(rtn is ShipManager):
            return(rtn)
    return(rtn)

func set_siblings(siblings: Array) -> void:
    self.engine_system = siblings[Global.ENGINE]
    self.LIDAR_system = siblings[Global.LIDAR]
    self.weapons_system = siblings[Global.WEAP]
    self.CPU_system = siblings[Global.CPU]
    self.sibling_flag=true
    
    all_systems = [self.menu_system, self.engine_system, self.LIDAR_system, self.weapons_system, self.CPU_system]

func set_focus(f) -> void:
    in_focus = f
    self.visible = f

func set_command_focus(t: bool) -> void:
    self.command_focus_open = t

func get_health() -> float:
    return(self.health)
func get_electricity() -> float:
    return(self.electricity)
func get_total_status() -> float:
    return(self.total_status)
func get_status() -> Array:
    return([self.health, self.electricity])

func update_ELC() -> void:
    #TODO
    pass

func update_UI_text() -> void:
    var output = ""
    output += "H: %.3f\t" % [self.health]
    output += "E: %.3f\t" % [self.electricity]
    output += "T: %.3f\t" % [self.total_status]
    self.ElecLubeHeat.set_text(output)
