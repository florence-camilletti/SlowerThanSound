extends Node2D

var num_enemies: int
var max_enemies = 1
var enemy_list: Array

func _ready() -> void:
    num_enemies = 0
    enemy_list = []

func _process(delta: float) -> void:
    if(num_enemies < max_enemies):
        print("MAKING NEW ENEMY")
        num_enemies+=1
