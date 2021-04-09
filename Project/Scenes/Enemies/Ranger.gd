extends "res://Scenes/Enemies/Enemy.gd"


const ARROW_SCENE = preload("res://Scenes/Enemies/Ranger_arrow.tscn")
const ARROW_SPEED = Vector2(10,0)

func _ready():
	_init_hp = 20
	SPEED = 20
	VELOCITY_X_LIMIT = 250
	hp = _init_hp
	
	animation_state_machine =$AnimationTree.get("parameters/playback")
	
func _physics_process(delta):
	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -VELOCITY_X_LIMIT, VELOCITY_X_LIMIT)
	
	if is_on_ceiling():
		velocity.y = 0
	
	fliping()
	
	if hp < _init_hp:
		VELOCITY_X_LIMIT = 100
		SPEED = 10
		var healer = is_healer_nearby()
		if healer != null:	
			healer.team_ask_for_help(self)

	if hurt:
		
		process_hurt()
		is_attacking  = false
	else:
		if is_on_floor():
			
			on_floor_physics()
			if attack:
				is_attacking  = true
				animation_state_machine.travel("Attack")

			if !is_attacking:
				
				if $Follow_Target.get_target():
					var distance_between = self.global_position.distance_to($Follow_Target.get_target().global_position)
				
					if $Follow_Target.get_target().is_in_group("Player"):
						
							if distance_between > 200:
								follow_target_sequence()# safe distance
							elif distance_between < 180:
								escape_from_target()# not safe, run
					else:
						follow_target_sequence()# safe distance
				if(abs(velocity.x) > 5):
					#he is running	
					animation_state_machine.travel("Run")			
				else:			
					#he is not moving
					animation_state_machine.travel("Idle")	

						
				
		else:
			
			in_air_physics()
			animation_state_machine.travel("Jump")	

	if hp <= 0:
		animation_state_machine.travel("Die")
		set_physics_process(false)
	

func _on_Effect_animation_finished():

	$Effect.visible = false
	pass

#grab by player
func on_grabed(force):
	velocity += force
	

func fire_arrow():
	var arrow_instnace = ARROW_SCENE.instance()
	get_parent().add_child(arrow_instnace)
	arrow_instnace.set_arrow_init_info($Animations/Arrow_Fire_Point.global_position,$Animations.scale.x, ARROW_SPEED * $Animations.scale.x)

func remove_from_targetable():
	remove_from_group("Enemy")
	set_collision_layer_bit( 2, false )

func _on_attack_start():
	is_attacking  = true

func _on_attack_finish():
	is_attacking  = false


func _on_Area2D_body_entered(body):

	if body.is_in_group("Player"):
		$Follow_Target.set_target(body)

func _on_Area2D_body_exited(body):
	if $Follow_Target.target_node == body:
		$Follow_Target.deselcet_target()

func _on_Attack_Area_body_entered(body):
	
	if body.is_in_group("Player"):
		var distance_between = self.global_position.distance_to(body.global_position)
		if distance_between > 200:
			attack = true
	

func _on_Attack_Area_body_exited(body):
	if body.is_in_group("Player"):
		attack = false
	



