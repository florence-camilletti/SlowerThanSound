extends ShipSystemBase

# === Map Vars ===
@onready var player_sprite := $PlayerSprite

var map_obstacles := []
var map_obstacle_pos := []

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
var entity_list := {} #Key - entity ID, Value - entity obj
var last_pos_list := {} #Key - entity ID, Value - vector2
var sprite_list := {} #Key - entity ID, Value - sprite obj
var label_list  := {} #Key - entity ID, Value - sprite obj
var selected_entity := "-1"
var label_offset := Vector2(5,5)

# === NOISE VARS ===
@onready var ping_noise := $LIDAR_Ping

func _init() -> void:
    super._init(false, Global.LIDAR)

func _ready() -> void:
    super._ready()
    
func set_map_manage(m: MapManager) -> void:
    self.map_manager = m

func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        #Update display
        self.update_display()
        
func _input(event: InputEvent) -> void:
    if(in_focus):
        if(self.command_focus_open):
            if(event.is_action_pressed("Action_U")):
                #Set auto-update rate
                self.inputBox.clear()
                self.inputBox.grab_focus()
                self.request_command_focus.emit()
    
func load_map(map_objects: Array) -> void:
    for old_obj in map_objects:
        var curr_polygons = old_obj.get_polygon()
        for indx in range(len(curr_polygons)):
            curr_polygons[indx] *= Global.desec_pixel_ratio
        var curr_position = old_obj.get_position()
        
        var new_object = Polygon2D.new()
        new_object.set_polygon(curr_polygons)
        new_object.set_position(curr_position)
        
        self.map_obstacles.append(new_object)
        self.map_obstacle_pos.append(curr_position)
        add_child(new_object)
        
    
#Update the rotation of the player sprite    
func update_sub_rotation(deg) -> void:
    #Update player
    self.player_sprite.set_rotation_degrees(deg)
         
func update_entity_list(new_entity_list: Array) -> void:
    for ent in new_entity_list:
        var ent_id = ent.get_id()
        self.entity_list[ent_id] = ent
        self.last_pos_list[ent_id] = ent.get_desec_pos()
    update_display()
        
#Update the position of the LIDAR sprites
func update_display() -> void:  
    var sub_pos = self.manager_node.sub_position
    
    #Update land
    for obst_indx in range(len(self.map_obstacles)):
            var new_pos = Global.desec_to_map(self.map_obstacle_pos[obst_indx], sub_pos)#self.manager_node.sub_position - self.map_obstacle_pos[obst_indx]
            self.map_obstacles[obst_indx].position = new_pos
              
    #Update entities
    for curr_entity in self.entity_list.values():
        var ent_id = curr_entity.get_id()
        var new_pos = Global.desec_to_map(self.last_pos_list[ent_id], sub_pos)
        self.sprite_list[ent_id].position = new_pos
        self.sprite_list[ent_id].set_rotation_degrees(curr_entity.get_heading())
        self.label_list[ent_id].position = new_pos + self.label_offset
        
    #Update selection box
    var show_select = self.selected_entity != "-1"
    if(show_select):
        self.selected_sprite.set_position(self.sprite_list[self.selected_entity].position)
        
#Increase the number of sprites
func add_new_entity(ent: EntityBase) -> void:
    var ent_id = ent.get_id()
    
    self.num_entities+=1
    var new_sprite = Sprite2D.new()
    new_sprite.set_texture(ent.get_texture())
    new_sprite.set_position(Vector2(-100,-100))
    self.sprite_list[ent_id] = new_sprite
    add_child(new_sprite)
    
    var new_label = RichTextLabel.new()
    new_label.set_text(ent.get_ID())
    new_label.set_position(new_sprite.get_position()+self.label_offset)
    new_label.set_size(Vector2(300,300))
    self.label_list[ent_id] = new_label
    add_child(new_label)
    
    self.entity_list[ent_id] = ent
    self.last_pos_list[ent_id] = Vector2.ZERO

func destroy_entity(ent: EntityBase) -> void:
    var ent_id = ent.get_id()
    
    self.entity_list.erase(ent_id)
    self.last_pos_list.erase(ent_id)
    var obj_tmp = self.sprite_list[ent_id]
    self.sprite_list.erase(ent_id)
    obj_tmp.queue_free()
    obj_tmp = self.label_list[ent_id]
    self.label_list.erase(ent_id)
    obj_tmp.queue_free()
    selected_entity = "-1"

#Updates the selection info when a new entity is selected
func update_selection(id: String) -> void:
    self.selected_sprite.set_visible(id != "-1")
    self.selected_entity = id

func refresh_map() -> void:
    #Update the entity list
    self.request_flag = true
    entity_request.emit()
    ping_noise.play()
    while(self.request_flag):#Wait for entity list
        pass

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
