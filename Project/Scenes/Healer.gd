extends KinematicBody2D

const SPEED = 30
const GARAVITY = 5
const JUMPFORCE = -200
const VELOCITY_X_LIMIT = 180
const FLOOR_NORMAL = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 12.0
const FLOOR_ANGLE = deg2rad(45)


var snap_vector = SNAP_DIRECTION * SNAP_LENGTH
var velocity = Vector2(0,0)
var animation_state_machine
var hp = 8



var hurt = false

func _ready():

	animation_state_machine =$AnimationTree.get("parameters/playback")
	
func _physics_process(delta):
	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -VELOCITY_X_LIMIT, VELOCITY_X_LIMIT)
	
	if is_on_ceiling():
		velocity.y = 0
	
	
	if hurt:
		$Effect.visible = true
		$Effect.frame = 0
		$Effect.play("Hit")
		print($Effect.animation)
		animation_state_machine.travel("Hurt")
		hurt = false
		
	else:
		if is_on_floor():
			
			velocity.x = lerp(velocity.x,0,0.05)
			animation_state_machine.travel("Idle")
			velocity = move_and_slide(velocity, Vector2.UP)
			snap_vector = SNAP_DIRECTION * SNAP_LENGTH
		else:
			velocity.y += GARAVITY
			#slow down speed	
			velocity.x = lerp(velocity.x,0,0.01)
			velocity = move_and_slide(velocity, Vector2.UP)
	

	if hp <= 0:
		print("died")
		animation_state_machine.travel("Die")
		set_physics_process(false)
	
func take_damage():
	if (hp > 0):
		hurt = true
		hp -= 2

		#animation_state_machine.travel("Shield_self")
	
func take_heavy_damage(amplifier):
	if (hp > 0):
		#animation_state_machine.travel("Shield_self")
		hurt = true
		var damage = 1 * amplifier
		print("damage is " + str(damage))
		if damage > 5:
			hp -= damage
		else:
			hp -= 5


func _on_Effect_animation_finished():
	#print("?")
	$Effect.visible = false
	pass

#grab by player
func on_grabed(force):
	velocity += force
	print(velocity)
	
	
func on_died():
	queue_free()
	
func remove_from_targetable():
	remove_from_group("Enemy")
	remove_from_group("Healer")

	set_collision_layer_bit(2, false )

