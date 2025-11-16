extends Node2D
class_name MapManager

# === NODE VARS ===
var manager_node: ShipManager

# === OBSTACLE VARS ===
@onready var land_objects := []

func _init() -> void:
    pass

func _ready() -> void:
    self.manager_node = self.find_parent_node()
    
func _process(delta: float) -> void:
    pass

func find_parent_node() -> ShipManager:
    var rtn = self
    while(rtn.get_parent()):
        rtn=rtn.get_parent()
        if(rtn is ShipManager):
            return(rtn)
    return(rtn)
    
#TODO: HAVE THIS READ FROM FILE
func load_map_polygons() -> void:
    var tmp_polygons = []
    tmp_polygons.append(PackedVector2Array([Vector2(0,0), Vector2(100,0), Vector2(100,100), Vector2(0,100)]))#Units are desec
    var tmp_pos = []
    tmp_pos.append(Global.map_middle+Vector2(-150, -150))
    self.build_map(tmp_polygons, tmp_pos)
 
#Create new polygon objects from the specified Vector points   
func build_map(polygons: Array, pos: Array) -> void:
    for poly_indx in range(len(polygons)):
        var new_poly = Polygon2D.new()
        new_poly.set_polygon(polygons[poly_indx])
        new_poly.set_position(pos[poly_indx])
        self.land_objects.append(new_poly)
        add_child(new_poly)

#Update the manager's state as to if the sub is going into illegal spots
func check_collision(ent_pos: Vector2) -> bool:
    for curr_land in self.land_objects:
        var new_pack = curr_land.get_polygon()
        if(Geometry2D.is_point_in_polygon(ent_pos-curr_land.get_position(), curr_land.get_polygon())):
            return(true)
    return(false)
