extends CharacterBody2D

@export var move_accel: float = 1000.0
@export var friction : float = 500.
@export var max_speed: float = 80.0
@export var jump_force: float = 180.0
@export var gravity: float = 700.0
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y > 0:
			velocity.y = 0

	var input_dir := Input.get_axis("ui_left", "ui_right")
	if input_dir == 0:
		velocity.x = move_toward(velocity.x, 0, delta * friction)
	else:
		velocity.x = move_toward(velocity.x, input_dir * max_speed, delta * move_accel)
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_force
	
func _process(_delta: float) -> void:
	move_and_slide()
