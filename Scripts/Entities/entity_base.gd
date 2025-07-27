extends Node2D
class_name EntityBase

var is_active: bool

var num: int
var type: String
var desec_pos: Vector2#Decisecond
var desec_vel: Vector2#Decisecond/tick
var desec_speed: float
var heading: float#0-360 degrees

var texture: Texture2D

func _init(n:int, t:String, p:Vector2, v:Vector2) -> void:
    self.is_active = true
    self.num = n
    self.type = t
    self.desec_pos = p
    
    self.set_desec_vel(v)

func _ready() -> void:
    pass
    
func _process(_delta: float) -> void:
    #Update entity pos
    if(self.is_active):
        self.desec_pos+=self.desec_vel

func set_texture(t: Texture2D) -> void:
    self.texture = t
func set_desec_pos(p: Vector2) -> void:
    self.desec_pos = p
func set_desec_vel(v: Vector2) -> void:
    self.desec_vel = v
    var tmp = Global.calc_desectic_speed(v)
    self.heading = tmp[0]
    self.desec_speed = tmp[1]

func get_texture() -> Texture2D:
    return(self.texture)
func get_desec_pos() -> Vector2:
    return(self.desec_pos)
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

func _to_string() -> String:
    return("ID: "+get_id()+", POS: "+str(self.desec_pos)+", VEL: "+str(self.desec_vel))
