extends EntityBase
class_name BasicTorp

var fuel := 10.0

func _init(i:int, p:Vector2, v:Vector2) -> void:
    super._init(i,"TB",p,v)
    self.texture = load("res://Assets/Textures/torpedo.png")
