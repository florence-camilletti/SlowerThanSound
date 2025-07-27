extends ShipSystemBase

var num_torps: int
var torp_fuel_size: int
var torp_fuel_rate: float

var torps_left_text: RichTextLabel

func _ready() -> void:
    torps_left_text = $TorpsLeft
    super._ready()
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        torps_left_text.set_text(str(num_torps))    
