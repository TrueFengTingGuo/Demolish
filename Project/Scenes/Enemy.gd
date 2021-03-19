extends KinematicBody2D


const SPEED = 20
const GARAVITY = 5
const JUMPFORCE = -200
const VELOCITY_X_LIMIT = 100
const FLOOR_NORMAL = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 12.0
const FLOOR_ANGLE = deg2rad(45)


var snap_vector = SNAP_DIRECTION * SNAP_LENGTH
var velocity = Vector2(0,0)
var animation_state_machine
var hp = 20
var _init_hp = 20

#AI
var found_player = true
var hurt = false
var attack = false
var is_attacking = false


func _ready():
	pass
	
func fliping():
	if velocity.x > 0:
		$Animations.scale.x = 1	
		$Follow_Target.scale.x = 1	
	elif velocity.x < 0:
		$Animations.scale.x = -1
		$Follow_Target.scale.x = -1	


func on_floor_physics():
	velocity = move_and_slide(velocity, Vector2.UP)
	snap_vector = SNAP_DIRECTION * SNAP_LENGTH
	velocity.x = lerp(velocity.x,0,0.1)

func in_air_physics():
						
	velocity.y += GARAVITY
	#slow down speed	
	velocity.x = lerp(velocity.x,0,0.01)
	velocity = move_and_slide(velocity, Vector2.UP)
	
func follow_target_sequence():
	#AI follow the traget
	$Follow_Target.follow_the_object(global_position)
	velocity.x += $Follow_Target.dircetion * SPEED
	if $Follow_Target.jump == 1 :
		velocity.y = JUMPFORCE	
		snap_vector = Vector2.ZERO * SNAP_LENGTH
		

func escape_from_target():
	$Follow_Target.follow_the_object(global_position)
	velocity.x += $Follow_Target.dircetion * SPEED * -1
	
		
func process_died():
	if hp <= 0:

		animation_state_machine.travel("Die")
		set_physics_process(false)
		
func process_hurt():
	#he is hurt, play hurt
	if hurt:
		$Effect.visible = true
		$Effect.play("Hit")
		animation_state_machine.travel("Hurt")
		hurt = false

		
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

		if damage > 5:
			hp -= damage
		else:
			hp -= 5

func get_healing(health):
	#print("healing")
	if hp > _init_hp:
		hp = _init_hp
		return false
	else: 
		hp += health
	return true


					
#grab by player
func on_grabed(force):
	velocity += force
	
	
func on_died():
	queue_free()
			
