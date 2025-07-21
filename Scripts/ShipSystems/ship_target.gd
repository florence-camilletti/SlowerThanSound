extends ShipSystemBase

# === SELECTION VARS ===
signal entity_request
var input_box: TextEdit
var entity_box: RichTextLabel
var selected_num: RichTextLabel
var entity_list := {}
signal new_selection
var auto_light: Sprite2D
var selected_entity: String
var selected_flag := false

# === TORPEDO VARS ===
var torps_left := 5
var torps_list := {}

func _ready() -> void:
    super._ready()
    self.input_box = $IDInput
    self.entity_box = $EntityList
    self.selected_num = $SelectionNumber
    self.auto_light = $AutoLight/AutoLightG
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        input_box.grab_focus()
        entity_request.emit()

func _input(event: InputEvent) -> void:
    if(in_focus):
        if(event.is_action_pressed("J")):
            #Attempt to launch a torpedo
            print("LAUNCH")
            if(self.torps_left>0):
                pass
        if(event.is_action_pressed("Enter")):
            #Entity seletion
            var selection = self.input_box.get_text()
            self.input_box.clear()
            var valid_select = selection in self.entity_list
            
            #selected_flag NAND selection==selected_entity
            self.selected_flag = (valid_select) and not (self.selected_flag and selection == self.selected_entity)
            if(self.selected_flag):
                self.selected_entity = selection
                self.selected_num.set_text(str(selection))
                self.new_selection.emit(selection)
            else:
                self.new_selection.emit("-1")
                
            self.selected_num.set_visible(self.selected_flag)
            self.auto_light.set_visible(self.selected_flag)

#Increase the number of entities
func add_new_entity(ent: EntityBase) -> void:
    self.entity_list[ent.get_id()] = 0
    
#TODO: Document
func update_list(new_entity_list) -> void:
    var output_str = ""
    var id = ""
    var distance = 0
    var direction_vec = Vector2(0,0)
    var direction_deg
    for e in new_entity_list:    
        id = e.get_id()
        distance = desec_nmile_ratio*calc_distance(e.desec_pos)
        direction_vec = manager_node.sub_position.direction_to(e.desec_pos)
        direction_deg = rad_to_deg(atan2(direction_vec[0], direction_vec[1]))
        if(direction_deg<0):
            direction_deg = 360+direction_deg
        output_str += id + (": %.4f, %.2f\n" % [distance, direction_deg])
        self.entity_list[id] = distance
    self.entity_box.set_text(output_str)
    
#Returns the distance in desec between the entity and the player
func calc_distance(entity_pos) -> float:
    return(manager_node.sub_position.distance_to(entity_pos))
