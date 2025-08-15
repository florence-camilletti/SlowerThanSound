extends ShipSystemBase

# === Map Vars ===
@onready var player_sprite := $PlayerSprite
var rng := RandomNumberGenerator.new()
var map_pixel_radius := 435
var map_pixel_center := Vector2(846,476)
var map_deg_radius := 0.01#+/- 0.01 degrees (0.6 nm) in each direction
var map_desec_radius := map_deg_radius*36000 #1 degree = 36,000 desecsec
#Final map is [-360,360] desecsec

# === Input Vars ===
@onready var inputBox := $AutoInput
@onready var autoLightG := $AutoLight/AutoLightG
@onready var autoBox := $AutoBox
@onready var timer := $SweepTimer
var autoFlag := false
var autoRate: float

# === Entity Vars ===
@onready var selected_sprite := $SelectionBox
signal entity_request
var request_flag := false
var num_entities := 0
var entity_list := {} #Key - entity ID, Value - entity obj
var sprite_list := {} #Key - entity ID, Value - sprite obj
var label_list  := {}
var selected_entity := "-1"
var label_offset := Vector2(20,20)

func _init() -> void:
    super._init(false, Global.LIDAR)

func _ready() -> void:
    super._ready()
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        pass

func _input(event: InputEvent) -> void:
    if(in_focus):
        if(self.command_focus_open):
            if(event.is_action_pressed("Action_U")):
                #Set auto-update rate
                self.inputBox.clear()
                self.inputBox.grab_focus()
                self.request_command_focus.emit()
        if(event.is_action_pressed("Enter")):
            if(self.inputBox.has_focus()):
                self.return_command_focus.emit()
                self.autoRate = float(self.inputBox.get_text())
                self.autoFlag = (autoRate!=0)
                self.autoLightG.set_visible(self.autoFlag)
                if(self.autoFlag):
                    #Start timer
                    self.timer.start(self.autoRate)
                    self.autoBox.set_text(str(self.autoRate))
                else:
                    #Stop timer
                    self.timer.stop()
                    self.autoBox.set_text("====")
                    
                self.inputBox.clear()
                self.inputBox.release_focus()
            
        if(event.is_action_pressed("Action_L")):
            refresh_map()
        
func update_sub_rotation(deg) -> void:
    #Update player
    self.player_sprite.set_rotation_degrees(deg)
         
#Update the position of the LIDAR sprites
func update_display(new_entity_list: Array) -> void:    
    #Update entities
    var sub_pos = self.manager_node.sub_position
    for curr_entity in new_entity_list:
        var new_pos = self.desec_to_map(curr_entity.get_desec_pos(), sub_pos)
        self.sprite_list[curr_entity.get_id()].position = new_pos
        self.sprite_list[curr_entity.get_id()].set_rotation_degrees(curr_entity.get_heading())
        self.label_list[curr_entity.get_id()].position = new_pos + self.label_offset
        
    #Update selection box
    var show_select = self.selected_entity != "-1"
    if(show_select):
        self.selected_sprite.set_position(self.sprite_list[self.selected_entity].position)
            
#Increase the number of sprites
func add_new_entity(ent: EntityBase) -> void:
    self.num_entities+=1
    var new_sprite = Sprite2D.new()
    new_sprite.set_texture(ent.get_texture())
    new_sprite.set_position(Vector2(-100,-100))
    self.sprite_list[ent.get_id()] = new_sprite
    add_child(new_sprite)
    
    var new_label = RichTextLabel.new()
    new_label.set_text(ent.get_ID())
    new_label.set_position(new_sprite.get_position()+self.label_offset)
    new_label.set_size(Vector2(300,300))
    self.label_list[ent.get_id()] = new_label
    add_child(new_label)
    
    self.entity_list[ent.get_id()] = ent

func destroy_entity(ent: EntityBase) -> void:
    entity_list.erase(ent.get_id())
    var obj_tmp = sprite_list[ent.get_id()]
    sprite_list.erase(ent.get_id())
    obj_tmp.queue_free()
    obj_tmp = label_list[ent.get_id()]
    label_list.erase(ent.get_id())
    obj_tmp.queue_free()
    selected_entity = "-1"

#TODO: document
func update_selection(id: String) -> void:
    self.selected_sprite.set_visible(id != "-1")
    self.selected_entity = id

#Translates a Vector2 of desecisecond position to a pixel position for sprite display
func desec_to_map(entity_pos: Vector2, sub_pos: Vector2) -> Vector2:
    #Get distance between sub and entity
    var distance = entity_pos-sub_pos
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
    #Update the entity list
    self.request_flag = true
    entity_request.emit()
    while(self.request_flag):#Wait for entity list
        pass

func _on_timer_timeout() -> void:
    #Automatically refresh LIDAR
    refresh_map()

func _on_auto_input_text_changed(_new_text: String) -> void:
    #Check for only nums
    if(not self.inputBox.text.is_empty() and not self.inputBox.text.is_valid_float()):
        self.inputBox.clear()
