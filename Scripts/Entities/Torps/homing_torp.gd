extends BasicTorp
class_name HomingTorp

func _init(i:int) -> void:
    super._init(i,"TH")
    
    self.texture = load("res://Assets/Textures/torpedo.png")

func _ready() -> void:
    super._ready()
    
func _process(_delta: float) -> void:
    super._process(_delta)
