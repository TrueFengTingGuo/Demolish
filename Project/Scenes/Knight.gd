extends KinematicBody2D

const SPEED = 50
const GARAVITY = 5
const JUMPFORCE = -200
const VELOCITY_X_LIMIT = 180
const FLOOR_NORMAL = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 12.0
const FLOOR_ANGLE = deg2rad(45)
const CHAIN_PULL = 20

var snap_vector = SNAP_DIRECTION * SNAP_LENGTH
var chain_velocity = Vector2(0,0)
var velocity = Vector2(0,0)
export var direction = -1

var get_down = false
var go_right = false
var go_left = false
var jump = false
var just_jump = false
var space = false


func _physics_process(delta):
	
	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -VELOCITY_X_LIMIT, VELOCITY_X_LIMIT)
	
	if is_on_ceiling():
		velocity.y = 0

	# if the player on the floor
	if is_on_floor():
		
		
		velocity.x = SPEED * direction
		$Sprite.play("Walk")
		
		if(direction == -1):
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false

		velocity = move_and_slide_with_snap(velocity, snap_vector ,FLOOR_NORMAL,true)	
		snap_vector = SNAP_DIRECTION * SNAP_LENGTH
		
	else:
		# if player is not on the floor
		if velocity.y > 0:
				$Sprite.play("Fall")
		else:
				$Sprite.play("Jump")
				
				
		velocity.y += GARAVITY
		#slow down speed	
		velocity.x = lerp(velocity.x,0,0.01)
		velocity = move_and_slide(velocity, Vector2.UP)
	
				
	if is_on_wall():
			direction *= -1	




