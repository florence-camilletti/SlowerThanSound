extends EntityBase
class_name BasicTorp

var torp_range := 300#Range in desec
var kill_bubble := 10#Radius in desec
var kill_bubble_square := kill_bubble*kill_bubble # Used for calculating distances
var damage_points := 200
var speedup := 0.1 #additional speed it gets

var target_id: String
var target: EntityBase

func _init(i:int, n:String) -> void:
    super._init(i,n,Vector2(0,0),Vector2(0,0))
    self.texture = load("res://Assets/Textures/torpedo.png")
    self.health=20

func _ready() -> void:
    super._ready()
    
func _process(_delta: float) -> void:
    super._process(_delta)
    if(self.is_alive):
        pass

func launch(pos: Vector2, head: float, s: float) -> void:
    self.heading = head
    self.desec_pos = pos
    self.desec_speed = s+self.speedup
    self.desec_vel = Global.calc_desectic_vel(self.heading, self.desec_speed)

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

func is_torp() -> bool:
    return(true)
