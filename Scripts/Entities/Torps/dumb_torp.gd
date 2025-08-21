extends BasicTorp
class_name DumbTorp

func _init(i:int) -> void:
    super._init(i,"TD")
    
    self.texture = load("res://Assets/Textures/torpedo.png")

func _ready() -> void:
    super._ready()
    
func _process(_delta: float) -> void:
    super._process(_delta)

func calculate_firing_plan() -> bool:
    var torp_pos = self.desec_pos
    var torp_speed = self.desec_speed
    var ship_pos = self.target.desec_pos
    var ship_speed = self.target.desec_speed
    var ship_vel = self.target.desec_vel
    
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
    self.target_pos = (ship_pos + (ship_vel*time_solution))
    #print("Ship curr pos: %.2f, %.2f" % [ship_pos[0], ship_pos[1]])
    #print("Torp curr pos: %.2f, %.2f" % [self.desec_pos[0], self.desec_pos[1]])
    #print("Intersect pos: %.2f, %.2f" % [self.target_pos[0], self.target_pos[1]])
    return(true)
