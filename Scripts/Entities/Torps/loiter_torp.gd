extends BasicTorp
class_name LoiterTorp

# === LOITER VARS ===
var loiter_flag := false
var chase_flag := false
var close_distance := 0.01
var prev_dist: float

func _init(i:int) -> void:
    super._init(i,"TL")
    
    self.texture = load("res://Assets/Textures/torpedo.png")

func _ready() -> void:
    super._ready()
    
func _process(_delta: float) -> void:
    super._process(_delta)
    if(self.armed):
        if(not self.loiter_flag):
            var dist_to_target = self.desec_pos.distance_squared_to(self.target_pos)
            self.loiter_flag = (dist_to_target>self.prev_dist)
            if(self.loiter_flag):
                self.set_desec_speed(0)
                
            self.prev_dist=dist_to_target
            #print(dist_to_target)

#To be written by child torps
#Generates the position to fire at if possible
func calculate_firing_plan(torp_pos: Vector2, torp_speed: float, ship_pos: Vector2, ship_speed: float, ship_vel: Vector2) -> bool:
    var relative_pos = ship_pos - torp_pos
    #Doing quadratic intercept formula to determine what launch angle should be given
    var a = (ship_speed*ship_speed) - (torp_speed*torp_speed)
    if(abs(a)<0.001):
        return(false)
    var b = 2*relative_pos.dot(ship_vel)
    var c = relative_pos.length_squared()
    var discrim = (b*b) - (4*a*c)
    if(discrim < 0):
        return(false)
        
    var sqrt_discrim = sqrt(discrim)
    var solution = [(-b + sqrt_discrim)/(2*a), (-b - sqrt_discrim)/(2*a)]#Calculate times for torpedo to intercept
    var time_solution = min(solution[0],solution[1])
    if(time_solution<0):#Bad solution, go to other one
        time_solution = max(solution[0],solution[1])
        if(time_solution<0):#Both solutions bad
            return(false)
    time_solution+=500
    self.target_pos = (ship_pos + (ship_vel*time_solution))
    self.prev_dist = self.desec_pos.distance_squared_to(self.target_pos)
    #print("Ship curr pos: %.2f, %.2f" % [ship_pos[0], ship_pos[1]])
    #print("Torp curr pos: %.2f, %.2f" % [self.desec_pos[0], self.desec_pos[1]])
    #print("Intersect pos: %.2f, %.2f" % [self.target_pos[0], self.target_pos[1]])
    return(true)
