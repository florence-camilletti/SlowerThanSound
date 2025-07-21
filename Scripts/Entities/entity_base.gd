extends Node2D
class_name EntityBase

var id: int
var type: String#TODO, what is this supposed to be?
var desec_pos: Vector2#Decisecond
var desec_vel: Vector2#Decisecond/tick

var sprite: Sprite2D

func _init(i, t, p, v) -> void:
    self.id = i
    self.type = t
    self.desec_pos = p
    self.desec_vel = v

func _ready() -> void:
    pass
    
func _process(delta: float) -> void:
    #Update enemy pos
    self.desec_pos+=self.desec_vel

func set_desec_pos(p) -> void:
    self.desec_pos = p
func set_desec_vel(v) -> void:
    self.desec_vel = v
func get_desec_pos() -> Vector2:
    return(self.desec_pos)
func get_desec_vel() -> Vector2:
    return(self.desec_vel)

func _to_string() -> String:
    return("ID: "+str(self.id)+", TYPE: "+str(self.type)+", POS: "+str(self.desec_pos)+", VEL: "+str(self.desec_vel))
