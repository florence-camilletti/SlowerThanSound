extends ShipSystemBase

# === Map Vars ===
@onready var player_sprite := $PlayerSprite
var active_flag := true

# === Input Vars ===
@onready var inputBox := $TopMask/AutoInput
@onready var autoLightG := $TopMask/AutoLight/AutoLightG
@onready var autoBox := $TopMask/AutoBox
@onready var timer := $SweepTimer
var autoFlag := false
var autoRate: float
signal signal_update

# === Entity Vars ===
@onready var selected_sprite := $SelectionBox
signal entity_request
var request_flag := false
var num_entities := 0
var entity_list := {} #Key - entity ID, Value - LocalEntity obj
var selected_entity := "-1"
var label_offset := Vector2(5,5)

# === NOISE VARS ===
@onready var ping_noise := $LIDAR_Ping

class LocalEntity:
    var ent_obj: EntityBase#TODO: Does it need ent_obj in it?
    var sprite_obj: Sprite2D
    var label_obj: RichTextLabel
    
    func _init(e, s, l):
        ent_obj=e
        sprite_obj=s
        label_obj=l

func _init() -> void:
    super._init(false, Global.LIDAR)

func _ready() -> void:
    super._ready()

func _process(delta: float) -> void:
    super._process(delta)
    if(in_focus):
        #Update display
        self.update_display()
        
func _input(event: InputEvent) -> void:
    #Process player input
    if(in_focus):
        if(self.command_focus_open):
            if(event.is_action_pressed("Action_U")):
                #Set auto-update rate
                self.inputBox.clear()
                self.inputBox.grab_focus()
                self.request_command_focus.emit()
            if(event.is_action_pressed("Action_F")):
                self.active_flag = not self.active_flag
    
func update_sub_pos(new_pos: Vector2) -> void:
    self.player_sprite.set_position(new_pos)

#Update the rotation of the player sprite    
func update_sub_rotation(deg) -> void:
    self.player_sprite.set_rotation_degrees(deg)

#Updates the selection info when a new entity is selected
func update_selection(id: String) -> void:
    self.selected_sprite.set_visible(id != "-1")
    self.selected_entity = id
         
func update_entity_list(new_entity_list: Array) -> void:
    for ent in new_entity_list:
        var ent_id = ent.get_id()
        var ent_pos = ent.get_position()
        self.entity_list[ent_id].ent_obj = ent
        self.entity_list[ent_id].sprite_obj.set_position(ent_pos)
        self.entity_list[ent_id].sprite_obj.set_rotation_degrees(ent.get_heading())
        self.entity_list[ent_id].label_obj.set_position(ent_pos+self.label_offset)
    update_display()
 
func refresh_map() -> void:
    #Update the entity list
    self.request_flag = true
    entity_request.emit()
    ping_noise.play()
    while(self.request_flag):#Wait for entity list
        pass
               
#Update the position of the LIDAR sprites
func update_display() -> void:  
    '''var sub_pos = self.manager_node.sub_position
              
    #Update entities
    for curr_entity in self.entity_list.values():
        var curr_ent_obj = curr_entity.ent_obj
        var ent_id = curr_ent_obj.get_id()
        var new_pos = Global.desec_to_map(self.entity_list[ent_id].last_pos, sub_pos, self.active_flag)
        self.entity_list[ent_id].sprite_obj.position = new_pos
        self.entity_list[ent_id].sprite_obj.set_rotation_degrees(curr_ent_obj.get_heading())
        self.entity_list[ent_id].label_obj.position = new_pos + self.label_offset'''
        
    #Update selection box
    if(self.selected_entity != "-1"):
        self.selected_sprite.set_position(self.sprite_list[self.selected_entity].position)
       
#Determines if an entity should be detected
func check_detection(curr_local_ent: LocalEntity, is_active: bool) -> bool:
    #TODO: FIll this out
    return(true)
    '''var curr_ent = curr_local_ent.ent_obj
    var final_detection: float
    if(is_active):
        final_detection = curr_ent.get_active_detection_level()
    else:
        final_detection = curr_ent.get_passive_detection_level()
    final_detection *= self.get_total_status()
    final_detection /= (manager_node.sub_position.distance_to(curr_ent.desec_pos))'''
     
#Increase the number of sprites
func add_new_entity(ent: EntityBase) -> void:
    var ent_id = ent.get_id()
    var ent_pos = ent.get_position()
    
    self.num_entities+=1
    var new_sprite = Sprite2D.new()
    new_sprite.set_texture(ent.get_texture())
    new_sprite.set_position(ent_pos)
    add_child(new_sprite)
    
    var new_label = RichTextLabel.new()
    new_label.set_text(ent.get_ID())
    new_label.set_position(ent_pos+self.label_offset)
    new_label.set_size(Vector2(300,300))
    add_child(new_label)
    
    var new_ent = LocalEntity.new(ent, new_sprite, new_label)
    self.entity_list[ent_id] = new_ent

func destroy_entity(ent: EntityBase) -> void:
    var ent_id = ent.get_id()
    
    self.entity_list.erase(ent_id)
    self.entity_list[ent_id].last_pos.erase(ent_id)
    var obj_tmp = self.entity_list[ent_id].sprite_obj
    self.sprite_list.erase(ent_id)
    obj_tmp.queue_free()
    obj_tmp = self.entity_list[ent_id].label_obj
    self.label_list.erase(ent_id)
    obj_tmp.queue_free()
    selected_entity = "-1"

func _on_timer_timeout() -> void:
    #Automatically refresh LIDAR
    refresh_map()

func _on_auto_input_text_changed(_new_text: String) -> void:
    #Check for only nums
    if(not self.inputBox.text.is_empty() and not self.inputBox.text.is_valid_float()):
        self.inputBox.clear()

func _on_auto_input_text_submitted(new_text: String) -> void:
    if(len(new_text)>0):
        self.autoRate = float(new_text)
        self.autoFlag = (autoRate!=0)
        self.autoLightG.set_visible(self.autoFlag)
        if(self.autoFlag):
            #Start timer
            self.timer.start(self.autoRate)
            self.autoBox.set_text(str(self.autoRate))
            self.signal_update.emit(true)
        else:
            #Stop timer
            self.timer.stop()
            self.autoBox.set_text("====")
            self.signal_update.emit(false)
                
    self.inputBox.clear()
    self.inputBox.release_focus()
