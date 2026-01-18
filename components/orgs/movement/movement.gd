extends Node

@export var working_area: Rect2i
@export var tile_generators: Array[AtmTileGenerator] = [] # Can't be a signal because order matters
@export var move_distance: int

signal MoveStarted(dir: Vector2i, speed: float)

var current_offset: Vector2i = Vector2i.ZERO

func _ready() -> void:
    _generate_tiles(working_area)
    start_move.call_deferred(Vector2i(0, -1))

###
### Animation
### 
const SPEED: float = 0.03

func start_move(dir: Vector2i) -> void:
    MoveStarted.emit(dir, move_distance*SPEED)
    var tween: Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
    tween.tween_method(_update_pos, Vector2(current_offset), Vector2(current_offset-dir*move_distance), SPEED*move_distance)
    
func _update_pos(target_offset: Vector2) -> void:
    ## TODO: can sometimes stop working at high speeds, if some positions are skipped
    var rounded_offset: Vector2i = round(target_offset)
    if rounded_offset != current_offset:
        var dir: Vector2i = current_offset - rounded_offset
        current_offset = rounded_offset
        _shift_map(dir)
        
    (get_parent() as Node2D).position = target_offset*16 - Vector2(current_offset*16)
        
    
###
### Tile generation
###
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
    
    _generate_tiles(_get_new_area_target(dir))
    
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
    
