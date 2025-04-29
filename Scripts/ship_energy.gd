extends ShipSystem

var energy_bar_path = "res://Assets/Textures/EnergyBar.png"

enum {HEADING, OXYGEN, AI, WEAPONS, BULKHEAD, TARGETING,
        ENGINE_LEFT, ENGINE_CENTER, ENGINE_RIGHT}
var bar_sprites = []
var curr_power = [0, 0, 0, 0, 0, 0, 0, 0, 0]
var max_power = [1, 1, 4, 2, 1, 3, 2, 2, 2]
var add_actions = ["1","2","Q","W","A","S","Z","X","C"]
var rem_actions = "SH"

func _ready() -> void:
    text_file_path = "res://Assets/Texts/Ship_Energy.txt"
    
    bar_sprites = [[$Bars/Bar_11],
                [$Bars/Bar_21],
                [$Bars/Bar_Q1,$Bars/Bar_Q2,$Bars/Bar_Q3,$Bars/Bar_Q4],
                [$Bars/Bar_W1,$Bars/Bar_W2],
                [$Bars/Bar_A1],
                [$Bars/Bar_S1,$Bars/Bar_S2,$Bars/Bar_S3],
                [$Bars/Bar_Z1,$Bars/Bar_Z2],
                [$Bars/Bar_X1,$Bars/Bar_X2],
                [$Bars/Bar_C1,$Bars/Bar_C2]]
                
    super._ready()
    
func _process(delta: float) -> void:
    if(in_focus):
        for indx in range(len(add_actions)):
            var action = add_actions[indx]
            if(Input.is_action_just_pressed(rem_actions+action)):#Remove energy
                print("REMOVE FROM "+action)
                curr_power[indx] = max(curr_power[indx]-1, 0)
                bar_sprites[indx][curr_power[indx]].visible = false
                
            elif(Input.is_action_just_pressed(action)):#Add energy
                print("ADD TO "+action)
                curr_power[indx] = min(curr_power[indx]+1, max_power[indx])
                bar_sprites[indx][curr_power[indx]-1].visible = true
