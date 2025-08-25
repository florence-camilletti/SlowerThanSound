extends EntityBase
class_name BasicEnemy

func _init(i:int, n:String, p:Vector2, v:Vector2) -> void:
    super._init(i,n,p,v)
    self.texture = load("res://Assets/Textures/enemy_tmp.png")
    self.health = 100

func _ready() -> void:
    super._ready()
    
func _process(_delta: float) -> void:
    super._process(_delta)
