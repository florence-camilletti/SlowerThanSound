extends ShipSystemBase

func _init() -> void:
    super._init(false, Global.BULK)
    
func _ready() -> void:
    super._ready()
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        pass
