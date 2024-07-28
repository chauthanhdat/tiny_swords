extends Node

@export var character : CharacterBody2D
@export var ground_layer = 1
@export var high_layer = 8
@export var tilemap : TileMap :
	set(value):
		tilemap = value
		layers = tilemap.get_layers_count()
		
var layers : int
var is_prev_tile_elevate : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var make_above_ground = _check_if_elevated() && character.z_index == 4
	
	_set_mask_and_collision(ground_layer, !make_above_ground)
	_set_mask_and_collision(high_layer, make_above_ground)

func _check_if_elevated() -> bool:
	var tile_under : Vector2i = tilemap.local_to_map(character.position)
	
	#print(tile_under)
	
	for layer in layers:
		var tile_data = tilemap.get_cell_tile_data(layer, tile_under)
		
		#if (tile_data):
			#print(tile_data.get_custom_data("elevate"))
		
		if tile_data && tile_data.get_custom_data("elevate"):
			if tile_data.get_custom_data("elevate_trigger"):
				character.z_index = 4
			return true
	
	character.z_index = 1
	return false
	
func _set_mask_and_collision(layer: int, value: bool):
	character.set_collision_layer_value(layer, value)
	character.set_collision_mask_value(layer, value)
