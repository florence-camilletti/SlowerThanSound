extends ShipSystemBase

var statusNumsText

func _ready() -> void:
    text_file_path = "res://Assets/Texts/Ship_Menu.txt"
    super._ready()
    self.in_focus = true
    self.visible = true
    
    self.statusNumsText = $StatusNums
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus):
        #Update text
        var txt_output = str(manager_node.heading) + "\n" + str(manager_node.delta_heading)
        statusNumsText.set_text(txt_output)
