extends EntityBase
class_name BasicEnemy

var health := 100

func _init(i:int, p:Vector2, v:Vector2) -> void:
    super._init(i,"EB",p,v)
    self.texture = load("res://Assets/Textures/enemy_tmp.png")

func _ready() -> void:
    super._ready()
    
func _process(_delta: float) -> void:
    super._process(_delta)
