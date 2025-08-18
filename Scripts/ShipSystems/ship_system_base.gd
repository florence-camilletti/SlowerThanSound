extends Node2D
class_name ShipSystemBase

# === META VARS ===
@onready var ElecLubeHeat = $ElecLubeHeat
var manager_node: ShipManager
var global_viewport: SubViewport
var in_focus: bool
var system_indx: int

# === THE TALKING STICK ===
@warning_ignore("unused_signal")
signal request_command_focus
@warning_ignore("unused_signal")
signal return_command_focus
var command_focus_open: bool

# === SIBLING VARS ===
var engine_system: ShipSystemBase#C1
var AI_system: ShipSystemBase
var bulk_system: ShipSystemBase
var power_system: ShipSystemBase#C2
var oxy_system: ShipSystemBase
var target_system: ShipSystemBase#C3
var weapons_system: ShipSystemBase
var LIDAR_system: ShipSystemBase

# === STATUS VARS ===
var health := 1.0
var electricity := 1.0
var lube := 1.0
var coolant := 1.0
var total_status := 1.0

func _init(f:bool, i:int) -> void:
    self.in_focus=f
    self.system_indx=i

func _ready() -> void:
    self.manager_node = get_parent().get_parent().get_parent().get_parent()#ew
        
    self.global_viewport = self.get_viewport()
    in_focus = false
    self.visible = false
    
func _process(_delta: float) -> void:
    update_ELC()

func set_siblings(siblings: Array) -> void:
    self.engine_system = siblings[Global.ENGINE]
    self.AI_system = siblings[Global.AI]
    self.bulk_system = siblings[Global.BULK]
    
    self.power_system = siblings[Global.POWER]
    self.oxy_system = siblings[Global.OXY]
    
    self.target_system = siblings[Global.TARGET]
    self.weapons_system = siblings[Global.WEAP]
    self.LIDAR_system = siblings[Global.LIDAR]

func set_focus(f) -> void:
    in_focus = f
    self.visible = f

func set_command_focus(t: bool) -> void:
    self.command_focus_open = t

func get_health() -> float:
    return(self.health)
func get_coolant() -> float:
    return(self.coolant)
func get_lube() -> float:
    return(self.lube)
func get_electricity() -> float:
    return(self.electricity)
func get_total_status() -> float:
    return(self.total_status)

func update_ELC() -> void:
    self.coolant = self.manager_node.get_coolant(self.system_indx)
    self.lube = self.manager_node.get_lube(self.system_indx)
    self.electricity = self.manager_node.get_electricity(self.system_indx)
    self.total_status = self.health*self.lube*self.electricity
    update_UI_text()

func update_UI_text() -> void:
    var output = ""
    output += "H: %.3f\t" % [self.health]
    output += "E: %.3f\t" % [self.electricity]
    output += "L: %.3f\t" % [self.lube]
    output += "C: %.3f\t" % [self.coolant]
    output += "T: %.3f\t" % [self.total_status]
    self.ElecLubeHeat.set_text(output)
