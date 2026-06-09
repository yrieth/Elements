extends CharacterBody2D

const BASE_RUN_SPEED: int = 350
const BASE_JUMP_HEIGHT: int = -1000
const BASE_GRAVITY: int = 2500


var orientation: bool
var run_speed: int
var jump_speed: int
var gravity: int
var orientation_penalty: float

func _ready() -> void:
	orientation = true
	orientation_penalty = 0.7
	calculate_movement()


func _process(delta: float) -> void:
	set_orientation(orientation)
	print(Input.get_last_mouse_velocity())

func _physics_process(delta) -> void:
	velocity.y += gravity * delta
	get_input()
	move_and_slide()

func calculate_movement() -> void:
	run_speed = BASE_RUN_SPEED
	jump_speed = BASE_JUMP_HEIGHT
	gravity = BASE_GRAVITY

func set_orientation(prev_orientation: bool) -> void:
	var cursor_pos: int = get_viewport().get_mouse_position().x - self.position.x
	orientation = cursor_pos > 0
	if prev_orientation != orientation:
		$Sprite2D.scale.x *= -1

func get_input() -> void:
	velocity.x = 0
	if is_on_floor() and Input.is_action_pressed("ui_accept"):
		velocity.y = jump_speed
	elif velocity.y < 0.0 and Input.is_action_just_released("ui_accept"):
		velocity.y *= 0.5
	
	if orientation:
		velocity.x = velocity.x + run_speed*(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")*orientation_penalty)
	else :
		velocity.x = velocity.x + run_speed*(Input.get_action_strength("ui_right")*orientation_penalty - Input.get_action_strength("ui_left"))
		
