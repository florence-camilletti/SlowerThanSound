extends ShipSystem

func _ready() -> void:
    text_file_path = "res://Assets/Texts/Ship_Menu.txt"
    super._ready()
    self.in_focus = true
    self.visible = true
    
func _process(delta: float) -> void:
    super._process(delta)
