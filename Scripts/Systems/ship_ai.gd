extends ShipSystem

func _ready() -> void:
    text_file_path = "res://Assets/Texts/Ship_AI.txt"
    super._ready()
    
func _process(delta: float) -> void:
    super._process(delta)
