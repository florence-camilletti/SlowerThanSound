extends BasicEnemy
class_name TurnEnemy

var turn_timer: Timer
var turn_rate := 2

func _init(i:int, p:Vector2, v:Vector2) -> void:
    super._init(i,"ET",p,v)

func _ready() -> void:
    super._ready()
    
    self.turn_timer = Timer.new()
    self.turn_timer.set_wait_time(0.1)
    self.turn_timer.set_one_shot(false)
    self.turn_timer.set_autostart(true)
    self.turn_timer.timeout.connect(_on_turn_timer_timeout)
    add_child(self.turn_timer)
    
func _process(_delta: float) -> void:
    super._process(_delta)

func _on_turn_timer_timeout() -> void:
    self.turn_right(turn_rate)
