extends Node2D
class_name EnemyBase

var id: int
var type: String
var pos: Vector2
var vel: Vector2

var sprite: Sprite2D

func _ready() -> void:
    sprite = Sprite2D.new()
    var image = Image.load_from_file(("res://Assets/Textures/angy.png"))
    sprite.set_texture(ImageTexture.create_from_image(image))
    add_child(sprite)
    
func _process(delta: float) -> void:
    pos+=vel

func set_pos(p) -> void:
    pos = p
func set_vel(v) -> void:
    vel = v
func get_pos() -> Vector2:
    return(pos)
func get_vel() -> Vector2:
    return(vel)
