extends ShipSystemBase

var statusNumsText

func _ready() -> void:
    super._ready()
    self.in_focus = true
    self.visible = true
    
    self.statusNumsText = $StatusNums
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        #Update text
        var txt_output = str(manager_node.heading) + "\n" + str(manager_node.delta_heading) + "\n"
        txt_output += str(manager_node.depth) + "\n" + str(manager_node.delta_depth) + "\n"
        txt_output += str(manager_node.speed) + "\n" + str(manager_node.delta_speed)
        statusNumsText.set_text(txt_output)
