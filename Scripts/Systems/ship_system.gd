extends Node2D
class_name ShipSystem

var in_focus: bool
var text_file_path
var text_node

func _ready() -> void:
    in_focus = false
    self.visible = false
    text_node = $Text
    var file = FileAccess.open(text_file_path, FileAccess.READ)
    text_node.set_text(file.get_as_text())
    
func _process(delta: float) -> void:
    pass

func set_focus(f) -> void:
    in_focus = f
    self.visible = f
