extends KinematicBody2D

const VELOCITY_X_LIMIT = 180
const FLOOR_NORMAL = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 12.0
const FLOOR_ANGLE = deg2rad(45)
const SPEED = 1

var velocity = Vector2(0,0)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	pass

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	var objectHit = move_and_collide(velocity)

	if objectHit:
		var collider = objectHit.get_collider()

		if collider.is_in_group('Player'):# if hook collide with a enemy
			if collider.take_damage():
				collider.velocity += self.global_position.direction_to(collider.global_position).normalized()
				queue_free()
			else:
				set_collision_mask_bit(1,false)
		elif collider.is_in_group('Wall') or collider.is_in_group('Cargo'):
			queue_free()
			
func set_arrow_init_info(position,direction,speed):

	$Sprite.scale.x = direction

	self.global_position = position

	velocity = speed * SPEED
	
