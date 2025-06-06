extends Node2D
class_name ShipSystemBase

var manager_node
var in_focus: bool
var text_file_path: String
var text_node: RichTextLabel

var health: int

func _ready() -> void:
    manager_node = get_parent()
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
