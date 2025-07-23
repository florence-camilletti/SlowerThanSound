extends EntityBase
class_name BasicTorp

var is_launched := false
var range := 300#Range in desec
var target: EntityBase
var speedup := 1/9 #additional speed it gets

func _init(i:int) -> void:
    super._init(i,"TB",Vector2(0,0),Vector2(0,0))
    self.texture = load("res://Assets/Textures/torpedo.png")

func _ready() -> void:
    super._ready()
    
func _process(_delta: float) -> void:
    super._process(_delta)

func launch(pos: Vector2, speed: Vector2) -> void:
    self.desec_pos = pos
    self.desec_speed = speed + speedup
    self.is_launched = true

func check_impact() -> bool:#TODO: THIS
    return(true)

func set_target(ent: EntityBase) -> void:
    self.target = ent
func get_target_pos() -> Vector2:
    return(target.get_pos())
func get_range() -> float:
    return(self.range)
