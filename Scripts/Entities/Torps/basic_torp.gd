extends EntityBase
class_name BasicTorp

# === PERFORMANCE VARS ===
var torp_range := 300#Range in desec
var kill_bubble := 10#Radius in desec
var kill_bubble_square := kill_bubble*kill_bubble # Used for calculating distances
var damage_points := 200

# === STARTUP VARS ===
var arming_timer: Timer
var arming_time := 4
var armed := false
var speedup := 0.2 #additional speed it gets

# === META VARS ===
var target_id: String
var target: EntityBase
var target_pos: Vector2

func _init(i:int, n:String) -> void:
    super._init(i,n,Vector2(0,0),Vector2(0,0))
    self.texture = load("res://Assets/Textures/torpedo.png")
    self.health=20

func _ready() -> void:
    super._ready()
    
    self.arming_timer = Timer.new()
    self.arming_timer.set_wait_time(self.arming_time)
    self.arming_timer.set_one_shot(true)
    self.arming_timer.timeout.connect(_on_arming_timer_timeout)
    add_child(self.arming_timer)
    
func _process(_delta: float) -> void:
    super._process(_delta)
    if(self.is_alive):
        pass

func launch(pos: Vector2, head: float, s: float) -> void:
    self.heading = head
    self.desec_pos = pos
    self.desec_speed = s+self.speedup
    self.desec_vel = Global.calc_desectic_vel(self.heading, self.desec_speed)
    self.arming_timer.start()

func BOOM() -> void:
    print(self.get_id())
    print("BOOM BOOM BOOM BOOM BOOM")
    set_health(0)

func set_target_id(ent_id: String) -> void:
    self.target_id = ent_id
func set_target(ent: EntityBase) -> void:
    self.target = ent
    
func get_target_id() -> String:
    return(self.target_id)
func get_target_pos() -> Vector2:
    return(target.get_pos())
func get_torp_range() -> float:
    return(self.torp_range)
func get_kill_bubble() -> float:
    return(self.kill_bubble)
func get_kill_bubble_sqr() -> float:
    return(self.kill_bubble_square)
func get_damage_points() -> int:
    return(self.damage_points)
func get_armed() -> bool:
    return(is_armed())

func is_torp() -> bool:
    return(true)
func is_armed() -> bool:
    return(self.armed)

func _on_arming_timer_timeout() -> void:
    self.armed = true
    if(calculate_firing_plan()):
        execute_firing_plan()

#To be written by child torps
func calculate_firing_plan() -> bool:
    return(false)

#Find the firing angle from torp to target and point torp that way
func execute_firing_plan() -> void:
    var direction_vec = self.desec_pos.direction_to(self.target_pos)
    var new_heading = rad_to_deg(atan2(direction_vec[0], direction_vec[1]))
    if(new_heading<0):
        new_heading+=360
    set_desec_vel(Global.calc_desectic_vel(new_heading, self.desec_speed))
