extends Node

@export var init_rect: Rect2i
@export var grid_size: Rect2i
@export var tile_size: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    fill_area(init_rect, Vector2i.ZERO)

###
### Tile filling
###
const CUTOFF: float = 0
func fill_area(rect: Rect2i, source_offset: Vector2i) -> void:
    var tilemap: TileMapLayer = get_parent() as TileMapLayer
    
    var y_start: int = ceil(float(rect.position.y+source_offset.y-tile_size.y-grid_size.position.y+1)/grid_size.size.y)
    var y_end: int = floor(float(rect.end.y+source_offset.y-1-grid_size.position.y)/grid_size.size.y)
    for x in range(rect.position.x, rect.end.x):
        for y in range(y_start, y_end+1):
            tilemap.set_pattern(Vector2i(x, y*grid_size.size.y+grid_size.position.y-source_offset.y), tilemap.tile_set.get_pattern(0))
            
    var x_start: int = ceil(float(rect.position.x+source_offset.x-tile_size.x-grid_size.position.x+1)/grid_size.size.x)
    var x_end: int = floor(float(rect.end.x+source_offset.x-1-grid_size.position.x)/grid_size.size.x)
    for y in range(rect.position.y, rect.end.y):
        for x in range(x_start, x_end+1):
            tilemap.set_pattern(Vector2i(x*grid_size.size.x+grid_size.position.x-source_offset.x, y), tilemap.tile_set.get_pattern(1))
            
    for x in range(x_start, x_end+1):
        for y in range(y_start, y_end+1):
            tilemap.set_pattern(
            Vector2i(x*grid_size.size.x+grid_size.position.x-source_offset.x, y*grid_size.size.y+grid_size.position.y-source_offset.y), 
            tilemap.tile_set.get_pattern(2)
            )