extends Node2D
class_name EntityBase

# === ID vars ===
signal death
var num: int#ID of the entity
var type: String#String abreviation of the entity
var texture: Texture2D

# === Status Vars ===
var health: int

# === Position vars ===
var desec_pos: Vector2#Decisecond position
var map_cell: Vector2

# === Movement Vars ===
var desec_vel: Vector2#Decisecond/tick
var desec_speed: float
var heading: float#0-360 degrees

func _init(n:int, t:String, p:Vector2, v:Vector2) -> void:
    self.num = n
    self.type = t
    
    self.set_desec_pos(p)
    self.set_desec_vel(v)

func _ready() -> void:
    pass
    
func _process(_delta: float) -> void:
    #Update entity pos
    if(self.is_alive):
        set_desec_pos(self.desec_pos+self.desec_vel)

func kill() -> void:
    set_health(0)
    death.emit(self)
func damage(d: int) -> void:
    self.health-=d
    if(self.health<=0):
        death.emit(self)
    
func set_health(h: int) -> void:
    self.health = h
    if(self.health<=0):
        death.emit(self)
func get_health() -> int:
    return(self.health)
func is_alive() -> bool:
    return(self.health>0)

func set_texture(t: Texture2D) -> void:
    self.texture = t
func set_desec_pos(p: Vector2) -> void:
    self.desec_pos = p
    self.map_cell = Vector2(floor(p[0]/Global.cell_size), floor(p[1]/Global.cell_size))
func set_desec_vel(v: Vector2) -> void:
    self.desec_vel = v
    var tmp = Global.calc_desectic_speed(v)
    self.heading = tmp[0]
    self.desec_speed = tmp[1]
func set_desec_speed(s: float) -> void:
    self.desec_speed = s
    var tmp = Global.calc_desectic_vel(self.heading, self.desec_speed)
    self.desec_vel = tmp
func set_desec_heading(h: float) -> void:
    self.heading = h
    var tmp = Global.calc_desectic_vel(self.heading, self.desec_speed)
    self.desec_vel = tmp
func turn_left(d: float) -> void:
    var tmp = self.heading-d
    while(tmp<0):
        tmp+=360
    set_desec_heading(tmp)
func turn_right(d: float) -> void:
    var tmp = self.heading+d
    while(tmp>360):
        tmp-=360
    set_desec_heading(tmp)

func get_texture() -> Texture2D:
    return(self.texture)
func get_desec_pos() -> Vector2:
    return(self.desec_pos)
func get_map_cell() -> Vector2:
    return(self.map_cell)
func get_desec_vel() -> Vector2:
    return(self.desec_vel)
func get_desec_speed() -> float:
    return(self.desec_speed)
func get_heading() -> float:
    return(self.heading)

func get_id() -> String:
    return(self.type+str(self.num))
func get_ID() -> String:
    return(get_id())

func is_torp() -> bool:
    return(false)
func is_torpedoe() -> bool:
    return(is_torp())
    
func _to_string() -> String:
    return("ID: "+get_id()+", POS: "+str(self.desec_pos)+", VEL: "+str(self.desec_vel))
