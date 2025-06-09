extends ShipSystemBase

var num_torps: int
var torp_fuel_size: int
var torp_fuel_rate: float

var torps_left_text

func _ready() -> void:
    torps_left_text = $TorpsLeft
    super._ready()
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        torps_left_text.set_text(str(num_torps))

func _input(event: InputEvent) -> void:
    if(in_focus):
        pass
        #TODO
        #Select torp tube
        #elif(event.is_action_pressed("O")):#Speed
        #TODO
        #Select what to load into it
        #TODO
        #Fuel and load torp
        #TODO
        #Select firing plan
        #TODO
        #Select fire time
    
