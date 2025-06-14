extends ShipSystemBase

var rng = RandomNumberGenerator.new()
var radius = 488
var center = Vector2(896,536)

var test_enemy
var test_enemy_img

func _ready() -> void:
    test_enemy_img = $TestEnemy
    super._ready()
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        pass

func _input(event: InputEvent) -> void:
    if(in_focus):
        if(event.is_action_pressed("U")):
            #Map update temp
            print("MAP")
            test_enemy = random_pos_test()
            test_enemy_img.set_position(test_pos_change(test_enemy))

func test_pos_change(v: Vector2) -> Vector2:
    var diff = v*radius
    return(center+diff)
    
func random_pos_test() -> Vector2:
    var rnd_x = rng.randf_range(-1, 1)
    var rnd_y = rng.randf_range(-1, 1)
    var enemy_pos = Vector2(rnd_x, rnd_y)
    print("ENEMY AT "+str(enemy_pos))
    return(enemy_pos)
