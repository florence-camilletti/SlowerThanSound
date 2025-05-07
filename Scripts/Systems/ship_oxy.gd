extends ShipSystem

enum {AI, BATTERY, ENGINE}
var sprites = []

var system_status = [false,false,false]
var room_status = [0.5,0.5,0.5]
var max_room_status = 1
var update_ticker
var update_start = 10

var add_actions = ["Q","A","Z"]
var rem_actions = "SH"

func _ready() -> void:
    text_file_path = "res://Assets/Texts/Ship_Oxy.txt"
    
    sprites = [$AISprite, $BatterySprite, $EngineSprite]
    update_ticker=update_start
    
    super._ready()
    
func _process(delta: float) -> void:
    #Process player input
    if(in_focus):
        for indx in range(len(add_actions)):
            var action = add_actions[indx]
            if(Input.is_action_just_pressed(rem_actions+action)):#Remove energy
                system_status[indx] = false
                    
            elif(Input.is_action_just_pressed(action)):#Add energy
                system_status[indx] = true
            
    #Process room status updating
    update_ticker-=1
    if(update_ticker==0):
        update_ticker=update_start
        for indx in range(len(sprites)):
            if(system_status[indx]):
                room_status[indx] = min(max_room_status, room_status[indx]+0.01)
            else:
                room_status[indx] = max(0, room_status[indx]-0.02)
                
            sprites[indx].modulate.a = room_status[indx]
        
