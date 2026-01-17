extends Node

@export var working_area: Rect2i
@export var tile_generators: Array[AtmTileGenerator] = [] # Can't be a signal because order matters

var current_offset: Vector2i = Vector2i.ZERO

func _ready() -> void:
    _generate_tiles(working_area)
    _on_move_end()

###
### Animation
### 
const SPEED: float = 0.1
func _move(dir: Vector2i) -> void:
    var tween: Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
    var target: CanvasItem = get_parent()
    current_offset -= dir
    tween.tween_property(target, "position", target.position - Vector2(dir*16), SPEED)
    tween.tween_callback(_shift_map.bind(dir))
    tween.tween_callback(_generate_tiles.bind(_get_new_area_target(dir)))
    tween.tween_callback(_on_move_end)
    
func _generate_tiles(area: Rect2i) -> void:
    for generator in tile_generators:
        generator.fill_area(area, current_offset)
    
func _shift_map(dir: Vector2i) -> void:
    var tilemap: TileMapLayer = get_parent()
    tilemap.position += Vector2(dir*16)
    
    var arr: PackedVector2Array = PackedVector2Array()
    arr.resize(working_area.size.x * working_area.size.y)
    var i: int = 0
    for y in range(working_area.position.y, working_area.end.y):
        for x in range(working_area.position.x, working_area.end.x):
            arr[i] = Vector2(x, y)
            i += 1
    
    var current_content: TileMapPattern = tilemap.get_pattern(arr)
    tilemap.set_pattern(working_area.position-dir, current_content)
    
func _get_new_area_target(dir: Vector2i) -> Rect2i:
    if dir == Vector2i(1, 0):
        return Rect2i(
            working_area.end.x-1,
            working_area.position.y,
            1,
            working_area.size.y
        )
    if dir == Vector2i(-1, 0):
        return Rect2i(
            working_area.position.x,
            working_area.position.y,
            1,
            working_area.size.y
        )
    if dir == Vector2i(0, 1):
        return Rect2i(
            working_area.position.x,
            working_area.end.y-1,
            working_area.size.x,
            1
        )
    if dir == Vector2i(0, -1):
        return Rect2i(
            working_area.position.x,
            working_area.position.y,
            working_area.size.x,
            1
        )
    return Rect2i(-1, -1, 0 ,0)
    
###
### Logic
### 
func _on_move_end() -> void:
    _move(Vector2i(1, 0))
