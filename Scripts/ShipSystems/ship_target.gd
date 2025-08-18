extends ShipSystemBase

# === SIGNAL VARS ===
signal check_ID

# === SELECTION VARS ===
@onready var inputBox = $EntityInput
@onready var selectedEntity = $TargetedEntity
@onready var selectedLight = $TargetLight/TargetLightG
var selected_entity_ID := "-1"
var selected_flag   := false
var wait_flag : bool

func _init() -> void:
    super._init(false, Global.TARGET)

func _ready() -> void:
    super._ready()
    
func _process(delta: float) -> void:
    super._process(delta)
    if(in_focus):
        pass

func _input(event: InputEvent) -> void:
    if(in_focus):
        if(self.command_focus_open):
            if(event.is_action_pressed("Action_I")):
                #Set auto-update rate
                self.inputBox.clear()
                self.inputBox.grab_focus()
                self.global_viewport.set_input_as_handled()
                self.request_command_focus.emit()
        if(event.is_action_pressed("Enter")):
            if(self.inputBox.has_focus()):
                var new_select = self.inputBox.get_text()
                var good_input = len(new_select)>0
                if(good_input):
                    self.selected_entity_ID = new_select
                    wait_flag = true
                    check_ID.emit(new_select)
                    while(wait_flag): pass
                    self.selectedLight.set_visible(self.selected_flag)
                    if(self.selected_flag):
                        self.selectedEntity.set_text(new_select)
                    else:
                        self.selectedEntity.set_text("====")
            
                self.inputBox.clear()
                self.inputBox.release_focus()
    
func get_selected_entity_ID() -> String:
    return(self.selected_entity_ID)
    
func update_selection(is_valid: bool) -> void:
    self.selected_flag = is_valid
    self.wait_flag = false
