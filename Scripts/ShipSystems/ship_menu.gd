extends ShipSystemBase

func _init() -> void:
    super._init(true, Global.MENU)

func _ready() -> void:
    super._ready()
    self.in_focus = true
    self.visible = true
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        pass
