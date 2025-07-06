extends ShipSystemBase

var request_flag: bool

var rng = RandomNumberGenerator.new()
var map_pixel_radius = 488
var map_pixel_center = Vector2(896,536)
var map_dec_size = Vector2(540000, 540000)
var map_deg_size = Vector2(30,30)

signal enemy_request
var num_enemies = 0
#Key - enemy ID, Value - enemy POS
var enemy_list = {}

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
            
            print(self.enemy_list)
            
#TODO
func update_enemies(enemies) -> void:
    for curr_enemy in enemies:
        self.enemy_list[curr_enemy.id].position = self.dec_pos_to_map_pos(curr_enemy.get_dec_pos())
            
#Increase the number of sprites
func add_new_enemy(id: int) -> void:
    num_enemies+=1
    var new_sprite = Sprite2D.new()
    var sprite_data = load("res://Assets/Textures/angy.png")
    new_sprite.set_texture(sprite_data)
    new_sprite.position = Vector2(-100,-100)
    self.enemy_list[id] = new_sprite
    add_child(new_sprite)

#TODO
func dec_pos_to_map_pos(dec_pos: Vector2) -> Vector2:
    #Divide dec pos by map size to get  ([-1, 1], [-1, 1]) range
    var rtn = dec_pos/self.map_dec_size
    #Multiple -1, 1 range by pixel radius (488) to get offset
    rtn *= self.map_pixel_radius
    #Add offset to map center (896,536)
    rtn += self.map_pixel_center
    return(rtn)
