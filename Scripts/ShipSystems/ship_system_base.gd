extends Node2D
class_name ShipSystemBase

var manager_node: ShipManager
var global_viewport: SubViewport
var in_focus: bool

var health := 1.0
var status := 1.0

func _ready() -> void:
    self.manager_node = get_parent().get_parent().get_parent()
        
    self.global_viewport = self.get_viewport()
    in_focus = false
    self.visible = false
    
func _process(_delta: float) -> void:
    pass

func set_focus(f) -> void:
    in_focus = f
    self.visible = f
