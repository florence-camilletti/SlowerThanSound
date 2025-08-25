extends BasicEnemy
class_name DumbEnemy

func _init(i:int, p:Vector2, v:Vector2) -> void:
    super._init(i,"ED", p, v)

func _ready() -> void:
    super._ready()
    
func _process(_delta: float) -> void:
    super._process(_delta)
