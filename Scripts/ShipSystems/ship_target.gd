extends ShipSystemBase

var selected_box := 0

# === SELECTION VARS ===
var target_input_box: TextEdit
var target_box: RichTextLabel
var target_selection_id_box: RichTextLabel
var target_auto_light: Sprite2D

signal new_selection
var entity_list := {}
var selected_target: String
var selected_target_flag := false

# === TORPEDO VARS ===
var torp_input_box: TextEdit
var torp_box: RichTextLabel
var torp_selection_id_box: RichTextLabel
var torp_auto_light: Sprite2D

signal torpedo_launched
var torps_left := {} #List of unlaunched torps
var torps_fired := {} #List of launched torps
var selected_torp: String
var selected_torp_flag := false

func _ready() -> void:
    super._ready()
    self.target_input_box = $Targeting/IDInput
    self.target_box = $Targeting/EntityList
    self.target_selection_id_box = $Targeting/SelectionID
    self.target_auto_light = $Targeting/AutoLight/AutoLightG
    
    self.torp_input_box = $Torpedo/IDInput
    self.torp_box = $Torpedo/TorpsLeft
    self.torp_selection_id_box = $Torpedo/SelectionID
    self.torp_auto_light = $Torpedo/AutoLight/AutoLightG
    
    var output_str = ""
    for n in range(5):#Dummy torpedoes
        var new_torp = BasicTorp.new(n)
        self.torps_left[new_torp.get_id()] = new_torp
        output_str += new_torp.get_ID()+": "+str(new_torp.get_range())+"\n"
    self.torp_box.set_text(output_str)
    
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        update_entity_list()#Refresh positions

func _input(event: InputEvent) -> void:
    if(in_focus):
        if(event.is_action_pressed("Action_U")):
            #Select a target
            self.selected_box = 1
            self.target_input_box.clear()
            self.target_input_box.grab_focus()
        if(event.is_action_pressed("Action_J")):
            #Select a torpedo
            self.selected_box = 2
            self.torp_input_box.clear()
            self.torp_input_box.grab_focus()
        if(event.is_action_pressed("Action_K")):
            #Launch tornado
            if(self.selected_torp_flag and self.selected_target_flag):
                launch_torpedo()
        if(event.is_action_pressed("Enter")):
            #Entity seletion
            if(self.selected_box==1):#Pull from target select box
                update_selection_target()
            elif(self.selected_box==2):#Pull from torpedo select box
                update_selection_torpedo()
            
            #Reset boxes
            self.target_input_box.release_focus()
            self.torp_input_box.release_focus()
            self.target_input_box.clear()
            self.torp_input_box.clear()

#TODO: Document
func update_selection_target() -> void:
    var selection = self.target_input_box.get_text().to_upper()
    var valid_select = selection in self.entity_list
                
    #selected_target_flag NAND selection==selected_target
    self.selected_target_flag = (valid_select) and not (self.selected_target_flag and selection == self.selected_target)
    if(self.selected_target_flag):
        self.selected_target = selection
        self.target_selection_id_box.set_text(str(selection))
        self.new_selection.emit(selection)
    else:
        self.new_selection.emit("-1")
                    
    self.target_selection_id_box.set_visible(self.selected_target_flag)
    self.target_auto_light.set_visible(self.selected_target_flag)
                
#TODO: Document
func update_selection_torpedo() -> void:
    var selection = self.torp_input_box.get_text().to_upper()
    var valid_select = selection in self.torps_left

    #selected_target_flag NAND selection==selected_target
    self.selected_torp_flag = (valid_select) and not (self.selected_torp_flag and selection == self.selected_torp)
    if(self.selected_torp_flag):
        self.selected_torp = selection
        self.torp_selection_id_box.set_text(str(selection))
                    
    self.torp_selection_id_box.set_visible(self.selected_torp_flag)
    self.torp_auto_light.set_visible(self.selected_torp_flag)
    
#Launches selected torpedo at selected target
func launch_torpedo() -> void:
    #Set up object launch
    var launch_torp = self.torps_left[self.selected_torp]
    var launch_target = self.entity_list[self.selected_target]
    launch_torp.set_target(launch_target)
    
    #Actually launch the torp
    launch_torp.launch(manager_node.sub_position, manager_node.calc_self_desectic_vel())
    self.torpedo_launched.emit(launch_torp)
    self.torps_left.erase(self.selected_torp)
    self.torps_fired[self.selected_torp] = launch_torp
    
    #Update torpedo list
    update_torpedo_list()

#Increase the number of entities
func add_new_entity(ent: EntityBase) -> void:
    self.entity_list[ent.get_id()] = ent
    
#Update the entity's position relative to the sub
#Calculates distance and heading to each entity for ease of targeting and identification
#And sets the text box accordingly
func update_entity_list() -> void:
    var output_str = ""
    var distance = 0
    var direction_vec = Vector2(0,0)
    var direction_deg
    for cur_key in self.entity_list:    
        var e = self.entity_list[cur_key]
        distance = Global.desec_nmile_ratio*calc_distance(e.desec_pos)
        direction_vec = manager_node.sub_position.direction_to(e.desec_pos)
        direction_deg = rad_to_deg(atan2(direction_vec[0], direction_vec[1]))
        if(direction_deg<0):
            direction_deg = 360+direction_deg
        output_str += e.get_id() + (": %.4f, %.2f\n" % [distance, direction_deg])
    self.target_box.set_text(output_str)
    
#Update the list of remaining torpedoes
#And set the text box accordingly
func update_torpedo_list() -> void:
    var output_str = ""
    for key in self.torps_left:
        var t = self.torps_left[key]
        output_str += t.get_id() +": "+str(t.get_range())+ "\n"
    self.torp_box.set_text(output_str)
    
#Returns the distance in desec between the entity and the player
func calc_distance(entity_pos) -> float:
    return(manager_node.sub_position.distance_to(entity_pos))

func _on_target_input_text_changed() -> void:
    pass#self.target_input_box.set_text(self.target_input_box.text.to_upper())

func _on_torpedo_input_text_changed() -> void:
    pass#self.torp_input_box.set_text(self.torp_input_box.text.to_upper())
