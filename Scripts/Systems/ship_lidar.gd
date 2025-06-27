extends ShipSystemBase

var rng = RandomNumberGenerator.new()
var radius = 488
var center = Vector2(896,536)
var map_size = Vector2(360,180)

var tmp_enemy:EnemyBase

func _ready() -> void:
    super._ready()
    
func _process(delta: float) -> void:
    super._process(delta)
    #Update enemy sprite
    if(self.tmp_enemy != null):
        pass
    #Process player input
    if(in_focus):
        pass

func _input(event: InputEvent) -> void:
    if(in_focus):
        pass
