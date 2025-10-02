extends Node2D
class_name MapManager

# === NODE VARS ===
var manager_node: ShipManager

# === OBSTACLE VARS ===
@onready var land_objects := []

func _init() -> void:
    pass

func _ready() -> void:
    self.manager_node = get_parent().get_parent().get_parent()
    
func _process(delta: float) -> void:
    pass

#TODO: HAVE THIS READ FROM FILE
func load_map_polygons(LIDAR_node: ShipSystemBase) -> void:
    var tmp_polygons = []
    tmp_polygons.append(PackedVector2Array([Vector2(0,0), Vector2(100,0), Vector2(100,100), Vector2(0,100)]))#Units are desec
    var tmp_desec_pos = []
    tmp_desec_pos.append(Global.map_middle+Vector2(-40, -40))
    self.build_map(tmp_polygons, tmp_desec_pos)
    self.give_map(LIDAR_node)
 
#Create new polygon objects from the specified Vector points   
func build_map(polygons: Array, pos: Array) -> void:
    for poly_indx in range(len(polygons)):
        var new_poly = Polygon2D.new()
        new_poly.set_polygon(polygons[poly_indx])
        new_poly.set_position(pos[poly_indx])
        self.land_objects.append(new_poly)

#Give the polygon data to the LIDAR node so it can make its own copy
func give_map(LIDAR_node: ShipSystemBase) -> void:
    LIDAR_node.load_map(self.land_objects)

#Update the manager's state as to if the sub is going into illegal spots
func check_collision(ent_pos_desec: Vector2) -> bool:
    var ent_pos_map = Global.desec_to_map(ent_pos_desec, manager_node.sub_position)
    for curr_land in self.land_objects:
        var curr_obj
        var new_pack = curr_land.get_polygon()
        var offset = Global.desec_to_map(curr_land.get_position(), manager_node.sub_position)
        for n in range(len(new_pack)):
            new_pack[n]+=offset
            
        if(Geometry2D.is_point_in_polygon(ent_pos_map, new_pack)):
            return(true)
    return(false)
