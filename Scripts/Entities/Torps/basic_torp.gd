extends EntityBase
class_name BasicTorp

var is_launched := false
var range := 300#Range in desec
var target: EntityBase
var speedup := 0.1 #additional speed it gets

func _init(i:int) -> void:
    super._init(i,"TB",Vector2(0,0),Vector2(0,0))
    self.texture = load("res://Assets/Textures/torpedo.png")

func _ready() -> void:
    super._ready()
    
func _process(_delta: float) -> void:
    super._process(_delta)

func launch(pos: Vector2, head: float, s: float) -> void:
    print("POS: %.2f, %.2f" % [pos[0], pos[1]])
    print("HEADING: %.2f" % head)
    print("SPEED:   %.2f" % s)
    self.desec_pos = pos
    var new_speed = s+self.speedup
    print("SPEED:   %.2f" % new_speed)
    self.heading = head
    self.desec_speed = new_speed
    self.desec_vel = Global.calc_desectic_vel(self.heading, self.desec_speed)

func check_impact() -> bool:#TODO: THIS
    return(true)

func set_target(ent: EntityBase) -> void:
    self.target = ent
func get_target_pos() -> Vector2:
    return(target.get_pos())
func get_range() -> float:
    return(self.range)
