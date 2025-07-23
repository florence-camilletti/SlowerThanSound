#Global.gd
extends Node

# === DISTANCES ===
#1 degree = 60 nautical miles (nmile) = 36000 deciseconds
#1 nmile = 1 minute = 60 seconds = 600 desec
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

#Changes heading and speed into a vector2 of how much the sub has moved in 1 tick
func calc_desectic_vel(curr_heading: float, speed: float) -> Vector2:
    #Translate heading (0-360 angle) into vector2 direction
    var x = sin(deg_to_rad(curr_heading))
    var y = cos(deg_to_rad(curr_heading))
    var direction_scale = Vector2(x, y)#Angle sub is pointing
    var new_vel = direction_scale * speed#desectics
    return(new_vel)
func calc_knot_vel(curr_heading: float, speed: float) -> Vector2:
    return(calc_desectic_vel(curr_heading, speed)*Global.desectic_ratio)
