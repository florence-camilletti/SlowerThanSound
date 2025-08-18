extends Node2D#THIS MAY NEED TO BE CHANGED BACK TO NODE2D IF IT GETS MESSY
class_name ShipManager

# === NODE VARS ===
@onready var global_view := $VC/V
@onready var entity_manager := $VC/V/EntityManager

@onready var menu_child   := $VC/V/SysChunkM/ShipMenu

@onready var engine_child := $VC/V/SysChunk1/ShipEngine
@onready var bulk_child   := $VC/V/SysChunk1/ShipBulk
@onready var AI_child     := $VC/V/SysChunk1/ShipAI
@onready var power_child  := $VC/V/SysChunk2/ShipPower
@onready var oxy_child    := $VC/V/SysChunk2/ShipOxy
@onready var LIDAR_child  := $VC/V/SysChunk3/ShipLIDAR
@onready var weap_child   := $VC/V/SysChunk3/ShipWeapons
@onready var target_child := $VC/V/SysChunk3/ShipTarget
var command_focus := true#If a text box is being focused

# === MENU VARS ===
var menu_choice := 0
var active_chunk := -1
var chunk_names := ["SysChunkM","SysChunk1","SysChunk2","SysChunk3"]
@onready var chunk_nodes := [[self.menu_child],#Chunk M
                              [self.engine_child, self.bulk_child, self.AI_child],#Chunk 1
                              [self.power_child, self.oxy_child],#Chunk 2
                              [self.target_child, self.weap_child, self.LIDAR_child]]#Chunk 3
@onready var all_system_nodes := [self.menu_child, self.engine_child, self.AI_child, self.bulk_child, 
                                  self.power_child, self.oxy_child, self.target_child, self.weap_child, self.LIDAR_child]
var num_chunks := len(chunk_names)

# === MOVEMENT VARS ===
#Location details in long,lat
var sub_position := Global.map_middle#Deciseconds; [0 - 720,000| 0 - 720,000]

var heading := 0.0#Degrees; 0 - 360
var desire_heading := 0.0
var turning_flag := false
var turn_direction := -1#1: CW, -1: CCW
var turn_speed := 0.0
var max_turn_speed := 1.0
var turn_speed_gain := 0.05

var depth := 0.0#Meters; 0 - 240
var desire_depth := 0.0
var diving_flag := false
var dive_direction := -1#1: Sink, -1: Raise
var dive_speed := 0.0
var max_dive_speed := 0.4
var dive_speed_gain := 0.01

var speed := 0.0#Desectics; 0 - 1/12
var max_accel := 0.1
var engine_power := 0.0# 0 - 100
var velocity := Vector2(0,0)#Speed and direction

# === SIDEBAR VARS ===
@onready var sidebar_engine := $VC/V/Sidebar/EngineStats
@onready var signal_text  := $VC/V/Sidebar/Signal

@onready var LLF_text := [$VC/V/Sidebar/Lock, $VC/V/Sidebar/Load, $VC/V/Sidebar/Flood]


func _ready() -> void:
    #Connecting signals
    self.target_child.check_ID.connect(on_entity_check)
    self.LIDAR_child.entity_request.connect(on_LIDAR_request)
    self.LIDAR_child.signal_update.connect(on_signal_update)
    self.entity_manager.entity_created.connect(on_entity_created)
    self.entity_manager.entity_destroyed.connect(on_entity_destroyed)
    self.weap_child.torpedo_launched.connect(on_torpedo_launch)
    
    for node in self.all_system_nodes:
        node.request_command_focus.connect(request_command_focus)
        node.return_command_focus.connect(return_command_focus)
            
    #Connecting systems to each other
    for node in self.all_system_nodes:
        node.set_siblings(self.all_system_nodes)

func request_command_focus() -> void:
    update_command_focus(false)
func return_command_focus() -> void:
    update_command_focus(true)
func update_command_focus(t: bool) -> void:
    self.command_focus = t
    for node in self.all_system_nodes:
        node.set_command_focus(t)

func _process(delta: float):
    #Update rotation
    if(self.turning_flag):
        self.turn_speed += self.turn_speed_gain*self.turn_direction*delta
        self.turn_speed = clamp(self.turn_speed, -self.max_turn_speed, self.max_turn_speed)#Update turning velocity
        self.heading+=turn_speed
        while(self.heading>360):#Make sure heading stays within 0-360
            self.heading-=360
        while(self.heading<0):
            self.heading+=360
        
        if(abs(self.heading-self.desire_heading)<=1):#If close enough, stop turning
            self.heading = self.desire_heading
            self.turn_speed = 0
            self.turning_flag = false
        
        self.LIDAR_child.update_sub_rotation(self.heading)
    
    #Update depth
    if(self.diving_flag):
        self.dive_speed += self.dive_speed_gain*self.dive_direction*delta
        self.dive_speed = clamp(self.dive_speed, -self.max_dive_speed, self.dive_speed)#Update diving speed
        self.depth+=self.dive_speed
        
        if(abs(self.depth-self.desire_depth)<=2):
            self.depth = self.desire_depth
            self.dive_speed = 0
            self.diving_flag = false
    
    #Update ship speed
    self.speed = self.speed + ((self.engine_power - (self.speed*Global.friction_coef))*delta)
    update_vel()
    self.sub_position+=self.velocity
    
    #Update sidebar
    update_sidebar()
    
func _input(event):
    if(event.is_action_pressed("Enter")):
        update_command_focus(true)
    for action_indx in range(self.num_chunks):
        if(event.is_action_pressed(chunk_names[action_indx])):#Check if a SysChunk event
            for chunk_indx in range(self.num_chunks):#Set the chunk focuses
                if(action_indx==chunk_indx):#Activate this chunk
                    self.command_focus = (self.active_chunk != chunk_indx) or self.command_focus
                    update_command_focus(self.command_focus)
                    self.active_chunk = chunk_indx
                    for system in self.chunk_nodes[chunk_indx]:
                        system.set_focus(true)
                else:#Deactivate these chunks
                    for system in self.chunk_nodes[chunk_indx]:
                        system.set_focus(false)
    
func _unhandled_input(event):#Quit on ESC
    if event is InputEventKey:
        if event.pressed and event.keycode == KEY_ESCAPE:
            get_tree().quit()
    
func start_turn() -> void:
    #Determine CW or CCW
    self.turning_flag = true
    var tmp = self.desire_heading-self.heading
    while(tmp<0):
        tmp+=360
    if(tmp<=180):
        #Clockwise
        self.turn_direction = 1
    else:
        #Counter-clockwise
        self.turn_direction = -1
    
func start_dive() -> void:
    #Determine dive or raise
    self.diving_flag = true
    if(self.desire_depth<self.depth):
        #Raise
        self.dive_direction = -1
    else:
        #Sink
        self.dive_direction = 1
        
func set_heading(h: float) -> void:
    self.heading = h
    self.update_vel()
func set_desire_heading(h: float) -> void:
    self.desire_heading = h
    start_turn()
func set_depth(d: float) -> void:
    self.depth = d
func set_desire_depth(d: float) -> void:
    self.desire_depth = d
    start_dive()
func set_speed(s: float) -> void:
    self.speed = s
    self.update_vel()
func set_engine_power(a: float) -> void:
    self.engine_power = self.max_accel*a/100
func update_vel() -> void:
    self.velocity = Global.calc_desectic_vel(self.heading, self.speed)
    
func emergency_speed() -> void:
    if(self.engine_power==0):
        self.engine_power=self.max_accel
    else:
        self.engine_power=0
func emergency_heading() -> void:
    self.set_desire_heading(int(self.heading+90)%360)
func emergency_depth() -> void:
    if(self.depth==0):
        self.set_desire_depth(50)
    else:
        self.set_desire_depth(0)
        
#Returns an arr about the sub's position and movement info    
func get_engine_info() -> Array:
    #[Speed, Power%, Heading, Depth]
    var rtn = [self.speed*Global.desectic_knot_ratio,
               self.engine_power/self.max_accel,
               self.heading,
               self.depth]
    return(rtn)
    
func get_viewport_object() -> Viewport:
    return(self.global_view)
    
func get_electricity(indx: int) -> float:
    return(self.power_child.get_indx_electricity(indx))
func get_lube(indx: int) -> float:
    return(self.oxy_child.get_indx_lube(indx))
func get_coolant(indx: int) -> float:
    return(self.oxy_child.get_indx_coolant(indx))
    
#TODO
func update_sidebar() -> void:
    #Update engine stats
    #POS, SPEED, ENGINE %, HEADING, DEPTH
    var output = ""
    var tmp_pos = self.sub_position*Global.desec_deg_ratio
    output += "%.4f, %.4f \n" % [tmp_pos[0], tmp_pos[1]]
    var tmp = self.get_engine_info()
    for i in tmp:
        output += "%.2f \n" % [i]
    self.sidebar_engine.set_text(output)
    
    #Update system stats
    
    #Update ELC
    
    #Update Signal
    
    #Update torp stats
    
#Update LIDAR's entity list from the entity manager
func on_LIDAR_request() -> void:
    var entity_list = self.entity_manager.get_entity_list()
    self.LIDAR_child.update_display(entity_list)
    self.LIDAR_child.request_flag = false

#Signaled by LIDAR when lidar timing is changed
func on_signal_update(s: bool) -> void:
    self.signal_text.set_visible(s)

#When ent has been created, update LIDAR and target
#Signaled by Entity Manager
func on_entity_created(ent: EntityBase) -> void:
    self.LIDAR_child.add_new_entity(ent)

#When ent had been destroyed, update LIDAR and target
#Signaled by Entity Manager
func on_entity_destroyed(ent: EntityBase) -> void:
    self.LIDAR_child.destroy_entity(ent)

#When new entity is selected
#Signaled by Target
func on_entity_check(curr_ent: String) -> void:
    if(self.entity_manager.check_ent_id(curr_ent)):
        self.target_child.update_selection(true)
        self.LIDAR_child.update_selection(curr_ent)
    else:
        self.target_child.update_selection(false)
        self.LIDAR_child.update_selection("-1")
        
#When weapons launches a torp obj
#Signaled by Weapons
func on_torpedo_launch(torp_obj: BasicTorp) -> void:
    self.entity_manager.add_torpedo(torp_obj)

func _to_string() -> String:
    var rtn = str(self.sub_position*Global.desec_deg_ratio) + "\n"
    rtn += ("%.2f \n%.2f\n" % [self.speed*Global.desectic_knot_ratio, self.engine_power/self.max_accel])
    rtn += ("%.2f \n%.2f" % [self.heading, self.depth])
    return(rtn)

func _on_signal_timer_timeout() -> void:
   self.signal_text.set_visible(false)
