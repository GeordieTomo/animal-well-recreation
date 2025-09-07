extends Sprite2D

var player : CharacterBody2D

var last_known_velocity_x : float = 0.

func _ready() -> void:
	player = get_parent()

func _process(_delta: float) -> void:
	if player == null:
		return
	# if velocity is not 0, then update direction of sprite
	if player.velocity.x != 0.:
		last_known_velocity_x = player.velocity.x
		set_sprite_direction(last_known_velocity_x)

func set_sprite_direction(velocity_x: float):
	flip_h = velocity_x < 0.
