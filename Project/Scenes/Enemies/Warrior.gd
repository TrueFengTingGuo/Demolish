#Credit for making a platformer AI https://www.youtube.com/watch?v=WXC8eBCEbho


extends "res://Scenes/Enemies/Enemy.gd"

func _ready():
	_init_hp = 20
	hp = _init_hp
	
	animation_state_machine =$AnimationTree.get("parameters/playback")
	
func _physics_process(delta):
	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -VELOCITY_X_LIMIT, VELOCITY_X_LIMIT)
	
	if is_on_ceiling():
		velocity.y = 0
	
	#change the direction of the sprite
	fliping()
	
	#ask for help
	if hp < _init_hp:
		var healer = is_healer_nearby()
		if healer != null:	
			healer.team_ask_for_help(self)	
			
	
	process_hurt()
	
	if is_on_floor():
		
		on_floor_physics()

		#print("attack " + str(attack) + "attack_finished " + str(attack_finished))		
			
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
		
		in_air_physics()
		
	process_died()
		


func _on_Effect_animation_finished():
	$Effect.visible = false

func remove_from_targetable():
	remove_from_group("Enemy")
	remove_from_group("Warrior")
	set_collision_layer_bit( 2, false )

func _on_Vision_body_entered(body):

	if body.is_in_group("Player"):
		$Follow_Target.set_target(body)
		
func _on_Vision_body_exited(body):
	if $Follow_Target.target_node == body:
		$Follow_Target.deselcet_target()

func _on_Attack_Area_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage()
		body.create_a_force_on_player(100 * self.global_position.direction_to(body.global_position).normalized().x)

func _on_Attack_area2_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage()
		body.create_a_force_on_player(300 * self.global_position.direction_to(body.global_position).normalized().x)


func _on_Attack_area3_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage()
		body.create_a_force_on_player(600 * self.global_position.direction_to(body.global_position).normalized().x)


func attack_dash():
	velocity.x +=  $Animations.scale.x  * 20* SPEED	
	
	
func _on_Attack_range_body_entered(body):	

	attack = true

func _on_Attack_range_body_exited(body):
	attack = false

func _on_attack_start():
	is_attacking  = true
	
func _on_attack_finish():
	$Animations/Attack_Area/CollisionShape2D.disabled = true
	$Animations/Attack_area2/CollisionShape2D.disabled = true
	$Animations/Attack_area3/CollisionShape2D.disabled = true
	is_attacking  = false
	attack = false

