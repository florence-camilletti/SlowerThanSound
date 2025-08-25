extends BasicTorp
class_name WireTorp

# === TURNING VARS ===
var turn_rate := 1
var turn_flag := [false, false]
var tube_selected := true

func _init(i:int) -> void:
    super._init(i,"TW")
    
    self.texture = load("res://Assets/Textures/torpedo.png")
    

func _ready() -> void:
    super._ready()
    
func _process(_delta: float) -> void:
    super._process(_delta)
    if(turn_flag[0]):
        self.turn_left(self.turn_rate)
    if(turn_flag[1]):
        self.turn_right(self.turn_rate)

func _input(event: InputEvent) -> void:
    if(self.tube_selected):
        if(event.is_action_pressed("Action_A")):
            self.turn_flag[0]=true
        if(event.is_action_pressed("Action_D")):
            self.turn_flag[1]=true
            
        if(event.is_action_released("Action_A")):
            self.turn_flag[0]=false
        if(event.is_action_released("Action_D")):
            self.turn_flag[1]=false

func set_tube_selected(b: bool) -> void:
    self.tube_selected=b
