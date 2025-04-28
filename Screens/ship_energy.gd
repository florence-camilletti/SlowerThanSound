extends Node

var in_focus: bool

var energy_bar_path = "res://Assets/Textures/EnergyBar.png"

enum {HEADING, OXYGEN, AI, WEAPONS, BULKHEAD, TARGETING,
        ENGINE_LEFT, ENGINE_CENTER, ENGINE_RIGHT}
var bar_sprites = []
var curr_power = [0, 0, 0, 0, 0, 0, 0, 0, 0]
var max_power = [1, 1, 4, 2, 1, 3, 2, 2, 2]
var add_actions = ["1","2","Q","W","A","S","Z","X","C"]
var rem_actions = "SH"

func _ready() -> void:
    in_focus = false
    bar_sprites = [[$Bar_11],
                [$Bar_21],
                [$Bar_Q1,$Bar_Q2,$Bar_Q3,$Bar_Q4],
                [$Bar_W1,$Bar_W2],
                [$Bar_A1],
                [$Bar_S1,$Bar_S2,$Bar_S3],
                [$Bar_Z1,$Bar_Z2],
                [$Bar_X1,$Bar_X2],
                [$Bar_C1,$Bar_C2]]
    
func _process(delta: float) -> void:
    if(in_focus):
        for indx in range(len(add_actions)):
            var action = add_actions[indx]
            if(Input.is_action_just_pressed(rem_actions+action)):#Remove energy
                print("REMOVE FROM "+action)
                curr_power[indx] = max(curr_power[indx]-1, 0)
                bar_sprites[indx][0].visible = false
                
            elif(Input.is_action_just_pressed(action)):#Add energy
                print("ADD TO "+action)
                curr_power[indx] = min(curr_power[indx]+1, max_power[indx])
                bar_sprites[indx][0].visible = true

func set_focus(f) -> void:
    in_focus = f
    self.visible = f
