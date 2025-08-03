extends ShipSystemBase

var torps_left_text: RichTextLabel

func _init() -> void:
    super._init(false, Global.WEAP)

func _ready() -> void:
    torps_left_text = $TorpsLeft
    super._ready()
