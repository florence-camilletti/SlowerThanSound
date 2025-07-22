extends EntityBase
class_name BasicTorp

var range := 0.5
var fuel := 10.0
var fuel_per_tick := 0.01
var target: EntityBase

func _init(i:int, p:Vector2, v:Vector2) -> void:
    super._init(i,"TB",p,v)
    self.texture = load("res://Assets/Textures/torpedo.png")

func _process(_delta: float) -> void:
    pass

func set_target(ent: EntityBase) -> void:
    self.target = ent
func get_target_pos() -> Vector2:
    return(target.get_pos())
func get_range() -> float:
    return(self.range)
func get_fuel() -> float:
    return(self.fuel)
