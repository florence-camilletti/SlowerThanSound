extends ShipSystemBase

# === TEXT VARS ===

@onready var ENG_text := [$ENG/Health, $ENG/Elec, $ENG/Lube, $ENG/Heat]
@onready var TRG_text := [$TRG/Health, $TRG/Elec, $TRG/Lube, $TRG/Heat]
@onready var WEP_text := [$WEP/Health,  $WEP/Elec,  $WEP/Lube,  $WEP/Heat]
@onready var CPU_text := [$CPU/Health, $CPU/Elec, $CPU/Lube, $CPU/Heat]
@onready var menu_options := [null, ENG_text, TRG_text, WEP_text, CPU_text]

func _init() -> void:
    super._init(true, Global.MENU)

func _ready() -> void:
    super._ready()
    self.in_focus = true
    self.visible = true
    
func _process(delta: float) -> void:
    super._process(delta)
    #Process player input
    if(in_focus and self.sibling_flag):
        update_all_boxes()

#TODO
func update_all_boxes() -> void:
    for n in range(1, len(menu_options)):
        update_box(n)

#TODO
func update_box(curr_indx: int) -> void:
    var new_data = self.all_systems[curr_indx].get_HELC()
    var curr_box = self.menu_options[curr_indx]
    for txt_indx in range(len(curr_box)):
            curr_box[txt_indx].set_text("%f" % new_data[txt_indx])
