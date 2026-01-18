extends Node

@export var animation_defs: Dictionary[Vector2i, ResCarAnimationDef] = {}

func _ready() -> void:
    _hide_all()

func _hide_all() -> void:
    for child in get_children():
        child.visible = false
    

func animate_move(dir: Vector2i, speed: float) -> void:
    if not animation_defs.has(dir):
        return
    var def: ResCarAnimationDef = animation_defs[dir]
    var node: Node2D = get_node(def.sprite)
    
    _hide_all()
    node.visible = true
    node.position = def.end_pos
    var tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
    tween.tween_property(node, "position", def.starting_pos, speed)
