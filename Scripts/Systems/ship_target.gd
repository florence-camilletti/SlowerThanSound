extends ShipSystemBase

signal enemy_request
var input_box: TextEdit
var enemy_box: RichTextLabel
var selected_num: RichTextLabel
var enemy_list := {}

var auto_light: Sprite2D
var selected_enemy: int
var selected_flag := false

func _ready() -> void:
    super._ready()
    self.input_box = $IDInput
    self.enemy_box = $EnemyList
    self.selected_num = $SelectionNumber
    self.auto_light = $AutoLight/AutoLightG
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        input_box.grab_focus()
        enemy_request.emit()

func _input(event: InputEvent) -> void:
    if(in_focus):
        if(event.is_action_pressed("Enter")):
            var selection = int(self.input_box.get_text())
            self.input_box.clear()
            var valid_select = selection in self.enemy_list
            
            #selected_flag NAND selection==selected_enemy
            self.selected_flag = (valid_select) and not (self.selected_flag and selection == self.selected_enemy)
            if(self.selected_flag):
                self.selected_enemy = selection
                self.selected_num.set_text(str(selection))
                
            self.selected_num.visible = self.selected_flag
            self.auto_light.visible = self.selected_flag

#Increase the number of sprites
func add_new_enemy(id: int) -> void:
    self.enemy_list[id] = 0
    
#TODO: Document
func update_list(enemy) -> void:
    var output_str = ""
    var id = 0
    var distance = 0
    for e in enemy:    
        id = e.id
        distance = desec_nmile_ratio*calc_distance(e.desec_pos)
        output_str += str(id) + ": " + str(distance) + "\n"
        self.enemy_list[id] = distance
    self.enemy_box.set_text(output_str)
    
#Returns the distance in desec between the enemy and the player
func calc_distance(enemy_pos) -> float:
    return(manager_node.sub_position.distance_to(enemy_pos))

func _on_id_input_text_changed() -> void:
    #Check for only nums
    if(not self.input_box.text.is_empty() and not self.input_box.text.is_valid_int()):
        self.input_box.clear()
