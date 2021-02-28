extends "res://Scenes/Enemy.gd"

var warrior_init_hp = 20

func _ready():
	hp = warrior_init_hp
	init_hp = warrior_init_hp
	animation_state_machine =$AnimationTree.get("parameters/playback")
	
func _physics_process(delta):
	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -VELOCITY_X_LIMIT, VELOCITY_X_LIMIT)
	
	if is_on_ceiling():
		velocity.y = 0
	
	fliping()
	
	process_hurt()
	
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
			if !is_attacking:
				if attack and !hurt :
					animation_state_machine.travel("Attack")
				else:
					if(abs(velocity.x) > 40):
						#he is running	
						animation_state_machine.travel("Run")			
					else:			
						#he is not moving
						animation_state_machine.travel("Idle")	
						
					follow_target_sequence()
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
	remove_from_group("Ranger")
	set_collision_layer_bit( 2, false )


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		$Follow_Target.set_target(body)
