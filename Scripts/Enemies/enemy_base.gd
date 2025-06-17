extends Node2D
class_name EnemyBase

var id: int
var type: String
var pos: Vector2
var vel: Vector2

var sprite: Sprite2D

func _ready() -> void:
    var image = Image.load_from_file(("res://Assets/Textures/angy.png"))
    self.sprite = Sprite2D.new()
    self.sprite.set_texture(ImageTexture.create_from_image(image))
    add_child(self.sprite)
    
func _process(delta: float) -> void:
    #Update enemy pos
    pos+=vel

func set_pos(p) -> void:
    self.pos = p
func set_vel(v) -> void:
    self.vel = v
func get_pos() -> Vector2:
    return(self.pos)
func get_vel() -> Vector2:
    return(self.vel)
