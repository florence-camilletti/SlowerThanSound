extends ShipSystemBase

var rng = RandomNumberGenerator.new()
var radius = 488
var center = Vector2(896,536)
var map_size = Vector2(360,180)

var tmp_enemy:EnemyBase
var test_text

func _ready() -> void:
    super._ready()
    test_text = $TestText
    
func _process(delta: float) -> void:
    super._process(delta)
    #Update enemy sprite
    if(self.tmp_enemy != null):
        var tmp_pos = self.tmp_enemy.get_pos()
        var tmp = str(tmp_pos) +"\n"
        tmp += str(test_pos_change(tmp_pos))
        test_text.set_text(tmp)
        self.tmp_enemy.set_position(test_pos_change(tmp_pos))
    #Process player input
    if(in_focus):
        pass

func _input(event: InputEvent) -> void:
    if(in_focus):
        if(event.is_action_pressed("U")):
            #Map update temp
            print("MAP")
            random_test()

func test_pos_change(p: Vector2) -> Vector2:
    var diff = p*radius
    diff /= manager_node.degree_translate
    diff /= self.map_size
    return(center+diff)
    
func random_test() -> void:
    self.tmp_enemy = EnemyBase.new()
    add_child(self.tmp_enemy)
    #Random speed
    var rnd_x = self.rng.randf_range(-1, 1)
    var rnd_y = self.rng.randf_range(-1, 1)
    var enemy_pos = Vector2(rnd_x, rnd_y)
    print("ENEMY AT "+str(enemy_pos))
    self.tmp_enemy.set_pos(enemy_pos)
    self.tmp_enemy.set_position(test_pos_change(enemy_pos))
    
    #Random speed
    #var rnd_head = self.rng.randf_range(0, 359)
    #var rnd_speed = self.rng.randf_range(0,20)
    var rnd_head = 0
    var rnd_speed = 5000
    var enemy_vel = manager_node.translate_speed(rnd_head, rnd_speed)
    self.tmp_enemy.set_vel(enemy_vel)
    print("ENEMY SPEED "+str(enemy_vel))
