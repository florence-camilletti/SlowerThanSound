extends BasicTorp
class_name DumbTorp

func _init(i:int) -> void:
    super._init(i,"TD")
    self.texture = load("res://Assets/Textures/torpedo.png")
    self.health=20

func _ready() -> void:
    super._ready()
    
func _process(_delta: float) -> void:
    super._process(_delta)
