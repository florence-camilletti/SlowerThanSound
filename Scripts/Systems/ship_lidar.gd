extends ShipSystemBase

# === Map Vars ===
var player_sprite: Sprite2D
var rng := RandomNumberGenerator.new()
var map_pixel_radius := 488
var map_pixel_center := Vector2(896,536)
var map_deg_radius := 0.01#+/- 0.01 degrees (0.6 nm) in each direction
var map_desec_radius := map_deg_radius*36000 #1 degree = 36,000 desecsec
#Final map is [-360,360] desecsec

# === Input Vars ===
var inputBox: TextEdit
var autoLightG: Sprite2D
var autoFlag := false
var autoRate: float
var timer

# === Enemy Vars ===
signal enemy_request
var request_flag := false
var num_enemies := 0
var enemy_list := {} #Key - enemy ID, Value - enemy POS
var selected_sprite: Sprite2D
var selected_enemy := -1

func _ready() -> void:
    super._ready()
    self.player_sprite = $PlayerSprite
    
    self.timer = $SweepTimer
    self.inputBox = $AutoInput
    self.autoLightG = $AutoLight/AutoLightG
    
    self.selected_sprite = $SelectionBox
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        pass

func _input(event: InputEvent) -> void:
    if(in_focus):
        if(event.is_action_pressed("K")):
            #Set auto-update rate
            self.inputBox.clear()
            self.inputBox.grab_focus()
        if(event.is_action_pressed("Enter")):
            self.autoRate = int(self.inputBox.get_text())
            self.autoFlag = (autoRate!=0)
            self.autoLightG.set_visible(self.autoFlag)
            if(self.autoFlag):
                #Start timer
                self.timer.start(self.autoRate)
            else:
                #Stop timer
                self.timer.stop()
                
            self.inputBox.clear()
            self.inputBox.release_focus()
            
        if(event.is_action_pressed("L")):
            refresh_map()
        
func update_sub_rotation(deg) -> void:
    #Update player
    self.player_sprite.set_rotation_degrees(deg)
         
#Update the position of the LIDAR sprites
func update_display(enemies) -> void:    
    #Update enemies
    var sub_pos = self.manager_node.sub_position
    for curr_enemy in enemies:
        self.enemy_list[curr_enemy.id].position = self.desec_to_map(curr_enemy.get_desec_pos(), sub_pos)
        
    #Update selection box
    var show_select = self.selected_enemy != -1
    if(show_select):
        self.selected_sprite.set_position(self.enemy_list[self.selected_enemy].position)
            
#Increase the number of sprites
func add_new_enemy(id: int) -> void:
    num_enemies+=1
    var new_sprite = Sprite2D.new()
    var sprite_data = load("res://Assets/Textures/enemy_tmp.png")
    new_sprite.set_texture(sprite_data)
    new_sprite.position = Vector2(-100,-100)
    self.enemy_list[id] = new_sprite
    add_child(new_sprite)

#TODO: document
func update_selection(id: int) -> void:
    self.selected_sprite.set_visible(id != -1)
    self.selected_enemy = id

#Translates a Vector2 of desecisecond position to a pixel position for sprite display
func desec_to_map(enemy_pos: Vector2, sub_pos: Vector2) -> Vector2:
    #Get distance between sub and enemy
    var distance = enemy_pos-sub_pos
    #Divide desec pos by map size to get  ([-1, 1], [-1, 1]) range
    var rtn = distance/self.map_desec_radius
    #Multiply -1, 1 range by pixel radius (488) to get offset
    rtn *= self.map_pixel_radius
    #Flip y-coord
    rtn *= Vector2(1,-1)
    #Add offset to map center (896,536)
    rtn += self.map_pixel_center
    return(rtn)

func refresh_map() -> void:
    #Update the enemy list
    self.request_flag = true
    enemy_request.emit()
    while(self.request_flag):#Wait for enemy list
        pass

func _on_timer_timeout() -> void:
    #Automatically refresh LIDAR
    refresh_map()

func _on_auto_input_text_changed() -> void:
    #Check for only nums
    if(not self.inputBox.text.is_empty() and not self.inputBox.text.is_valid_int()):
        self.inputBox.clear()
