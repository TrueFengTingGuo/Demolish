extends "res://Scenes/Enemy.gd"

var _init_hp = 20
const ARROW_SCENE = preload("res://Scenes/Ranger_arrow.tscn")
const ARROW_SPEED = Vector2(10,0)

func _ready():
	hp = _init_hp
	init_hp = _init_hp
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
						
					escape_from_target()
		else:
			velocity.y += GARAVITY
			#slow down speed	
			velocity.x = lerp(velocity.x,0,0.01)
			velocity = move_and_slide(velocity, Vector2.UP)
	

	if hp <= 0:
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

		if damage > 5:
			hp -= damage
		else:
			hp -= 5


func _on_Effect_animation_finished():

	$Effect.visible = false
	pass

#grab by player
func on_grabed(force):
	velocity += force
	
func on_died():
	queue_free()
	
func fire_arrow():
	var arrow_instnace = ARROW_SCENE.instance()
	get_parent().add_child(arrow_instnace)
	arrow_instnace.set_arrow_init_info($Animations/Arrow_Fire_Point.global_position,$Animations.scale.x, ARROW_SPEED * $Animations.scale.x)
func remove_from_targetable():
	remove_from_group("Enemy")
	remove_from_group("Ranger")
	set_collision_layer_bit( 2, false )

func _on_attack_start():
	is_attacking  = true
	fire_arrow()
	
	
func _on_attack_finish():
	is_attacking  = false
	

func _on_Area2D_body_entered(body):
	# if body.is_in_group("Player"):
		# $Follow_Target.set_target(body)

	if body.is_in_group("Healer") and  hp/_init_hp < 0.2:

		$Follow_Target.set_target(body)

	elif body.is_in_group("Player"):
		$Follow_Target.set_target(body)

func _on_Area2D_body_exited(body):
	if $Follow_Target.target_node == body and body.is_in_group("Player"):
		$Follow_Target.deselcet_target()
		if(!is_attacking):
			velocity.x *= -1
	elif $Follow_Target.target_node == body:
		$Follow_Target.deselcet_target()
		


func _on_Attack_Area_body_entered(body):
	if body.is_in_group("Player"):
		attack = true


func _on_Attack_Area_body_exited(body):
	if body.is_in_group("Player"):
		attack = false



