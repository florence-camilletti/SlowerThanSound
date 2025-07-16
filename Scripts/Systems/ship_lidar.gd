extends ShipSystemBase

var request_flag: bool

var rng = RandomNumberGenerator.new()
var map_pixel_radius = 488
var map_pixel_center = Vector2(896,536)
var map_deg_radius = Vector2(0.1,0.1)#+/- 0.1 degrees (~10 km) in each direction
var map_dec_size = map_deg_radius*36000 #1 degree = 360,000 decsec

signal enemy_request
var num_enemies = 0
#Key - enemy ID, Value - enemy POS
var enemy_list = {}
var player_sprite

func _ready() -> void:
    super._ready()
    self.request_flag = false
    self.player_sprite = $PlayerSprite
    
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
        
func update_sub_pos(pos, deg) -> void:
    #Update player
    self.player_sprite.position = self.dec_to_map(pos)
    self.player_sprite.set_rotation_degrees(deg)
         
#Update the position of the LIDAR sprites
func update_display(enemies) -> void:    
    #Update enemies
    for curr_enemy in enemies:
        self.enemy_list[curr_enemy.id].position = self.dec_to_map(curr_enemy.get_dec_pos())
            
#Increase the number of sprites
func add_new_enemy(id: int) -> void:
    num_enemies+=1
    var new_sprite = Sprite2D.new()
    var sprite_data = load("res://Assets/Textures/enemy_tmp.png")
    new_sprite.set_texture(sprite_data)
    new_sprite.position = Vector2(-100,-100)
    self.enemy_list[id] = new_sprite
    add_child(new_sprite)

#Translates a Vector2 of decisecond position to a pixel position for sprite display
func dec_to_map(dec_pos: Vector2) -> Vector2:
    #TODO: HAVE THIS MOVE WITH THE PLAYER
    #Divide dec pos by map size to get  ([-1, 1], [-1, 1]) range
    var rtn = dec_pos/self.map_dec_size
    #Multiply -1, 1 range by pixel radius (488) to get offset
    rtn *= self.map_pixel_radius
    #Flip y-coord
    rtn *= Vector2(1,-1)
    #Add offset to map center (896,536)
    rtn += self.map_pixel_center
    return(rtn)
