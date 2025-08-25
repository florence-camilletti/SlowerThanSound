extends BasicTorp
class_name HomingTorp

# === HOMING VARS ===
var is_homing := false
var homing_timer: Timer

func _init(i:int) -> void:
    super._init(i,"TH")
    
    self.texture = load("res://Assets/Textures/torpedo.png")

func _ready() -> void:
    super._ready()
    
    self.homing_timer = Timer.new()
    self.homing_timer.set_wait_time(0.1)
    self.arming_timer.set_one_shot(false)
    self.arming_timer.timeout.connect(_on_homing_timer_timeout)
    add_child(arming_timer)
    
    self.target.desec_speed*=1.5
    
func _process(_delta: float) -> void:
    super._process(_delta)
    if(self.armed):
        var direction_vec = self.desec_pos.direction_to(self.target.desec_pos)
        var new_heading = rad_to_deg(atan2(direction_vec[0], direction_vec[1]))
        if(new_heading<0):
            new_heading+=360
        set_desec_vel(Global.calc_desectic_vel(new_heading, self.desec_speed))

func _on_homing_timer_timeout() -> void:
    #Recalculate aiming angle
    '''var direction_vec = self.desec_pos.direction_to(self.target.desec_pos)
    var new_heading = rad_to_deg(atan2(direction_vec[0], direction_vec[1]))
    if(new_heading<0):
        new_heading+=360
    set_desec_vel(Global.calc_desectic_vel(new_heading, self.desec_speed))'''
    print("TIME")

func execute_firing_plan() -> void:
    super.execute_firing_plan()
    self.arming_timer.start()
