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
    enemy_list = format_enemy_list(enemy)

#TODO: Document    
func format_enemy_list(enemy) -> Array:
    print(enemy)
    for e in enemy:
        print(e)
        print(e.id)
    return([1,2,3])
    
