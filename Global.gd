#Global.gd
extends Node

# === SHIP SYSTEMS ===
enum {MENU,ENGINE,POWER,OXY,AI,BULK,TARGET,WEAP,LIDAR}
var systems := ["MENU","ENGINE","POWER","OXY","AI","BULK","TARGET","WEAP","LIDAR"]#Names of systems

# === DISTANCES ===
#1 degree = 60 nautical miles (nmile) = 36000 deciseconds
#1 nmile = 1 minute = 60 seconds = 600 desec
#1 decisecond ~= 3.09 meters

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

# === MAP ===
var map_middle := Vector2(18000, 18000)
var map_size   := Vector2(36000, 36000)
var map_offset := Vector2(4392000, 144000)
var map_limit  := Vector2(4428000, 180000)
var cell_size := 50

# === PHYSICS ===
var friction_coef := 0.5

# === TORPEDO ===
enum {DUMB, HOMING, LOITER, WIRE}
var load_times := [1, 6, 6, 10]#TODO: CHANGE THIS BACK

#Changes heading and speed into a velocity vector of how much the sub has moved in 1 tick
func calc_desectic_vel(curr_heading: float, speed: float) -> Vector2:
    #Translate heading (0-360 angle) into vector2 direction
    var x = sin(deg_to_rad(curr_heading))
    var y = cos(deg_to_rad(curr_heading))
    var direction_scale = Vector2(x, y)#Angle sub is pointing
    var new_vel = direction_scale * speed#desectics
    return(new_vel)
func calc_knot_vel(curr_heading: float, speed: float) -> Vector2:
    return(calc_desectic_vel(curr_heading, speed)*Global.desectic_knot_ratio)

#Changes a velocity vector into heading and speed
#Returns Vector2[Heading, Speed]
func calc_desectic_speed(curr_velocity: Vector2) -> Vector2:
    var speed = curr_velocity.length()
    
    var direction = rad_to_deg(atan2(curr_velocity[0], curr_velocity[1]))
    if(direction<0):
        direction+=360
    return(Vector2(direction, speed))
func calc_knot_speed(curr_velocity: Vector2) -> Vector2:
    return(calc_desectic_speed(curr_velocity)*Global.desectic_knot_ratio)
