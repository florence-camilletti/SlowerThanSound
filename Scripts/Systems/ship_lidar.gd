extends ShipSystem

func _ready() -> void:
    text_file_path = "res://Assets/Texts/Ship_LIDAR.txt"
    super._ready()
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        pass
