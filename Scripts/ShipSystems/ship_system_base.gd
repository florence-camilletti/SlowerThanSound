extends Node2D
class_name ShipSystemBase

var manager_node#: ShipManager
var in_focus: bool

var health: int

# === DISTANCES ===
#1 degree = 60 nautical miles (nmile) = 36000 deciseconds
#1 nmile = 1 minute = 60 seconds
#1 decisecond = 3.09 meters

#1 degree = 60 nmiles
var deg_nmile_ratio := 60
var nmile_deg_ratio := 1/60.0
#1 degree = 36000 desec
var deg_desec_ratio := 36000
var desec_deg_ratio := 1/36000.0
#1 nmile = 600 desec
var nmile_desec_ratio := 600
var desec_nmile_ratio := 1/600.0

# === SPEEDS ===
#1 tick = 1/60 second
#1 hour = 216000 ticks
#1 knot = 1 nmile/hour = 600 decisecond/216000 ticks = 1 decisecond/360 ticks (1/360 desectic)

#1 knot = 1/360 decisecond/tick
#1 decisecond/tick = 360 knots
var desectic_knot_ratio := 360
var knot_desectic_ratio := 1/360.0

func _ready() -> void:
    manager_node = get_parent()
    in_focus = false
    self.visible = false
    
func _process(delta: float) -> void:
    pass

func set_focus(f) -> void:
    in_focus = f
    self.visible = f
