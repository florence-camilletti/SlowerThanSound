extends ShipSystemBase

signal enemy_request

var enemy_box: RichTextLabel
var enemy_list := []

func _ready() -> void:
    super._ready()
    enemy_box = $EnemyList
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        enemy_request.emit()

func _input(event: InputEvent) -> void:
    pass

#TODO: Document
func update_list(enemy) -> void:
    enemy_list = enemy
    update_enemy_text(enemy)

#TODO: Document    
func update_enemy_text(enemy) -> void:
    var output_str = ""
    for e in enemy:
        output_str += str(e.id) + ": " + str(calc_distance(e.desec_pos)) + "\n"
    self.enemy_box.set_text(output_str)
    
#Returns the distance in desec between the enemy and the player
func calc_distance(enemy_pos) -> float:
    return(manager_node.sub_position.distance_to(enemy_pos))
