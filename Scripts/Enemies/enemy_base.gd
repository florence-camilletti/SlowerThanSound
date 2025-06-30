extends Node2D
class_name EnemyBase

var id: int
var type: String
var dec_pos: Vector2#Deciseconds
var dec_vel: Vector2#Deciseconds/tick

var sprite: Sprite2D

func _init(i, t, p, v) -> void:
    self.id = i
    self.type = t
    self.dec_pos = p
    self.dec_vel = v

func _ready() -> void:
    pass
    
func _process(delta: float) -> void:
    #Update enemy pos
    self.dec_pos+=self.dec_vel

func set_dec_pos(p) -> void:
    self.dec_pos = p
func set_dec_vel(v) -> void:
    self.dec_vel = v
func get_dec_pos() -> Vector2:
    return(self.dec_pos)
func get_dec_vel() -> Vector2:
    return(self.dec_vel)

func _to_string() -> String:
    return("ID: "+str(self.id)+", TYPE: "+str(self.type)+", POS: "+str(self.dec_pos)+", VEL: "+str(self.dec_vel))
