extends Node2D
class_name EnemyBase

var id: int
var type: String
var dec_pos: Vector2#Deciseconds
var dec_vel: Vector2#Deciseconds/tick

var sprite: Sprite2D

func _ready() -> void:
    var image = Image.load_from_file(("res://Assets/Textures/angy.png"))
    self.sprite = Sprite2D.new()
    self.sprite.set_texture(ImageTexture.create_from_image(image))
    add_child(self.sprite)
    
func _process(delta: float) -> void:
    #Update enemy pos
    self.dec_pos+=self.dec.vel

func set_dec_pos(p) -> void:
    self.dec_pos = p
func set_dec_vel(v) -> void:
    self.dec_vel = v
func get_dec_pos() -> Vector2:
    return(self.dec_pos)
func get_dec_vel() -> Vector2:
    return(self.dec_vel)
