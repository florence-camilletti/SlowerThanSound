extends ShipSystemBase

enum {DUMB, HOMING, LOITER, WIRE}
var torps_left = [5, 5, 5, 5]

signal bool_test

func _init() -> void:
    super._init(false, Global.WEAP)

func _ready() -> void:
    super._ready()
    
func _input(event: InputEvent) -> void:
    if(self.in_focus):        
        if(event.is_action_pressed("Action_K")):
            pass
