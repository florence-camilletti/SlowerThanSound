extends ShipSystemBase

var request_flag: bool

var rng = RandomNumberGenerator.new()
var radius = 488
var center = Vector2(896,536)
var map_size = Vector2(360,180)
var tmp_map = Vector2(60,30)

signal enemy_request
var num_enemies = 0
var enemy_sprite_list = []

func _ready() -> void:
    super._ready()
    self.request_flag = false
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        pass

func _input(event: InputEvent) -> void:
    if(in_focus):
        if(event.is_action_pressed("L")):
            #Update the enemy list
            self.request_flag = true
            enemy_request.emit()
            while(self.request_flag):
                pass
            
            print(self.enemy_sprite_list)
