extends KinematicBody2D

const VELOCITY_X_LIMIT = 180
const FLOOR_NORMAL = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 12.0
const FLOOR_ANGLE = deg2rad(45)
const SPEED = 0.3

var velocity = Vector2(0,0)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	pass
			


func set_arrow_init_info(position,direction,speed):
	print("self.global_position")
	print(self.global_position)
	$Sprite.scale.x = direction
	# self.global_position = position
	velocity = speed * SPEED
	
