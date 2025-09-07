extends SubViewport

@export var tile_map_to_render : TileMapLayer

func _ready() -> void:
	if get_child_count()>0.:
		for child in get_children():
			child.queue_free()
	var duplicate_tilemap = tile_map_to_render.duplicate()
	add_child(duplicate_tilemap)
	duplicate_tilemap.global_position = tile_map_to_render.global_position
