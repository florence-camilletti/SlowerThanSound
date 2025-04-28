extends Node2D

var menu_choice: int;
var menu_text

var menu_file_text
var heading_file_text
var energy_file_text
var ai_file_text
var oxy_file_text
var bulk_file_text
var weapons_file_text
var targeting_file_text

var energy_node

var ship_sprite
var system_sprite

func _ready() -> void:
    menu_choice = 0
    menu_text = $MenuText
    energy_node = $ShipEnergy
    ship_sprite = $ShipSprite
    system_sprite = $SystemSprite
    
    menu_file_text = read_file("res://Assets/Texts/Ship_Menu.txt")
    heading_file_text = read_file("res://Assets/Texts/Ship_Heading.txt")
    energy_file_text = read_file("res://Assets/Texts/Ship_Energy.txt")
    ai_file_text = read_file("res://Assets/Texts/Ship_AI.txt")
    oxy_file_text = read_file("res://Assets/Texts/Ship_Oxy.txt")
    bulk_file_text = read_file("res://Assets/Texts/Ship_Bulk.txt")
    weapons_file_text = read_file("res://Assets/Texts/Ship_Weapons.txt")
    targeting_file_text = read_file("res://Assets/Texts/Ship_Targeting.txt")

func _process(delta: float) -> void:
    if(Input.is_action_just_pressed("MENU_QUIT")):#Go up a menu
        menu_choice = 0
        energy_node.set_focus(false)
    if(Input.is_action_just_pressed("HEADING")):#Where you're going
        menu_choice = 1
    if(Input.is_action_just_pressed("ENERGY")):#What has power
        menu_choice = 2
        energy_node.set_focus(true)
    if(Input.is_action_just_pressed("AI")):#What the computers are focusing on
        menu_choice = 3
    if(Input.is_action_just_pressed("OXYGEN")):#Oxygen managment
        menu_choice = 4
    if(Input.is_action_just_pressed("BULKHEAD")):#Doors
        menu_choice = 5
    if(Input.is_action_just_pressed("WEAPONS")):#Weapon managment
        menu_choice = 6
    if(Input.is_action_just_pressed("TARGETING")):#Weapon targeting
        menu_choice = 7
        
    match menu_choice:
        0:#Menu
            display_menu()
        1:#Heading
            display_heading()
        2:#Energy
            display_energy()
        3:#AI
            display_AI()
        4:#Oxygen
            display_oxy()
        5:#Bulkhead
            display_bulk()
        6:#Weapons
            display_weapons()
        7:#Targeting
            display_targeting()

func read_file(path):
    var file = FileAccess.open(path, FileAccess.READ)
    var content = file.get_as_text()
    return content

func display_menu():
    ship_sprite.visible = true
    system_sprite.visible = true
    menu_text.set_text(menu_file_text)
    system_sprite.texture = load("res://Assets/Textures/Ships/Ship_Default.png")

func display_heading():#MOVE TO MAP MENU
    ship_sprite.visible = false
    system_sprite.visible = false
    menu_text.set_text(heading_file_text)
    
func display_energy():#MOVE TO ship_energy.gd
    ship_sprite.visible = true
    system_sprite.visible = true
    menu_text.set_text(energy_file_text)
    system_sprite.texture = load("res://Assets/Textures/Ships/Ship_Energy.png")
    

func display_AI():
    ship_sprite.visible = true
    system_sprite.visible = true
    menu_text.set_text(ai_file_text)
    system_sprite.texture = load("res://Assets/Textures/Ships/Ship_AI.png")
    
func display_oxy():
    ship_sprite.visible = true
    system_sprite.visible = true
    menu_text.set_text(oxy_file_text)
    system_sprite.texture = load("res://Assets/Textures/Ships/Ship_Pumps.png")

func display_bulk():
    ship_sprite.visible = true
    system_sprite.visible = true
    menu_text.set_text(bulk_file_text)
    system_sprite.texture = load("res://Assets/Textures/Ships/Ship_Bulkheads.png")
    
func display_weapons():
    ship_sprite.visible = true
    system_sprite.visible = true
    menu_text.set_text(weapons_file_text)
    system_sprite.texture = load("res://Assets/Textures/Ships/Ship_Weapons.png")

func display_targeting():#MOVE TO ENEMY VIEW
    ship_sprite.visible = false
    system_sprite.visible = false
    menu_text.set_text(targeting_file_text)
