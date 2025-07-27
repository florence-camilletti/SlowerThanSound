extends Node2D
class_name ShipSystemBase

var manager_node#: ShipManager
var in_focus: bool

var health: int

func _ready() -> void:
    manager_node = get_parent()
    in_focus = false
    self.visible = false
    
func _process(_delta: float) -> void:
    pass

func set_focus(f) -> void:
    in_focus = f
    self.visible = f
