extends AtmTileGenerator

@export var noise: FastNoiseLite

###
### Tile filling
###
const CUTOFF: float = 0
func fill_area(rect: Rect2i, source_offset: Vector2i) -> void:
    if not self.visible:
        return

    var terrain_0: Array[Vector2i] = []
    var terrain_1: Array[Vector2i] = []
    
    for x in range(rect.position.x, rect.end.x):
        for y in range(rect.position.y, rect.end.y):
            var pos: Vector2i = Vector2i(x, y)
            terrain_0.append(pos)
            if noise.get_noise_2dv((pos-source_offset)*16) > CUTOFF:
                terrain_1.append(pos)
                
    (get_parent() as TileMapLayer).set_cells_terrain_connect(terrain_0, 0, 0)
    (get_parent() as TileMapLayer).set_cells_terrain_connect(terrain_1, 0, 1) 
    
