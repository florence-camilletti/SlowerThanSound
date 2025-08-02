extends ShipSystemBase

@onready var statusNumsText := $StatusNums

func _ready() -> void:
    super._ready()
    self.in_focus = true
    self.visible = true
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        #Update text
        statusNumsText.set_text(manager_node.get_sub_info())
