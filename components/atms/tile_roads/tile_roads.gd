extends AtmTileGenerator

@export var grid_size: Rect2i
@export var tile_size: Vector2i

@export_group("DEBUG")
@export var DEBUG_generate_horizontal: bool = true
@export var DEBUG_generate_vertical: bool = true
@export var DEBUG_generate_crossroad: bool = true

###
### Tile filling
###
const CUTOFF: float = 0
func fill_area(rect: Rect2i, source_offset: Vector2i) -> void:
    if not self.visible:
        return

    var tilemap: TileMapLayer = get_parent() as TileMapLayer
    
    var y_start: int = ceil(float(rect.position.y-source_offset.y-tile_size.y-grid_size.position.y+1)/grid_size.size.y)
    var y_end: int = floor(float(rect.end.y-source_offset.y-1-grid_size.position.y)/grid_size.size.y)
    if DEBUG_generate_horizontal:
        for x in range(rect.position.x, rect.end.x):
            for y in range(y_start, y_end+1):
                tilemap.set_pattern(Vector2i(x, y*grid_size.size.y+grid_size.position.y+source_offset.y), tilemap.tile_set.get_pattern(0))
            
    var x_start: int = ceil(float(rect.position.x-source_offset.x-tile_size.x-grid_size.position.x+1)/grid_size.size.x)
    var x_end: int = floor(float(rect.end.x-source_offset.x-1-grid_size.position.x)/grid_size.size.x)
    if DEBUG_generate_vertical:
        for y in range(rect.position.y, rect.end.y):
            for x in range(x_start, x_end+1):
                tilemap.set_pattern(Vector2i(x*grid_size.size.x+grid_size.position.x+source_offset.x, y), tilemap.tile_set.get_pattern(1))

    if DEBUG_generate_crossroad:
        for x in range(x_start, x_end+1):
            for y in range(y_start, y_end+1):
                tilemap.set_pattern(
                    Vector2i(x*grid_size.size.x+grid_size.position.x+source_offset.x, y*grid_size.size.y+grid_size.position.y+source_offset.y), 
                    tilemap.tile_set.get_pattern(2)
                )
