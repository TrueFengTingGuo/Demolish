#Credit for making a platformer AI https://www.youtube.com/watch?v=WXC8eBCEbho


extends "res://Scenes/Enemies/Enemy.gd"


var heal = false
var running = true
var is_hurt = false
var single = null

func _ready():
	hp = _init_hp
	SPEED = 5
	animation_state_machine =$AnimationTree.get("parameters/playback")
	
func _physics_process(delta):
	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -VELOCITY_X_LIMIT, VELOCITY_X_LIMIT)
	
	if is_on_ceiling():
		velocity.y = 0
	
	#change the direction of the sprite
	fliping()
		
	
	if hurt:
		stop_healing()
		process_hurt()
	else:
		if is_on_floor():
			
			if heal:
				#print("HHH")
				if single: 
					if single.get_healing(delta * 2):
						
						$Follow_Target.deselcet_target()#stop it from moving
						running = false
						animation_state_machine.travel("Healing")
					else:
						heal = false
						animation_state_machine.travel("Idle")
			elif(abs(velocity.x) > 40) and running :

				animation_state_machine.travel("Run")	
				heal = false	
					
			else:			
				animation_state_machine.travel("Idle")	
			
			if $Follow_Target.get_target():
				if ($Follow_Target.get_target().is_in_group("Enemy")):		
					follow_target_sequence()
				elif $Follow_Target.get_target().is_in_group("Player"):
					escape_from_target()
				
			on_floor_physics()
				
		else:	
			
			in_air_physics()
		
	process_died()
		
func stop_healing():
	if heal == true:
		heal = false
	running = true
	
func _on_Effect_animation_finished():
	$Effect.visible = false

func remove_from_targetable():
	remove_from_group("Enemy")
	#remove_from_group("Warrior")
	set_collision_layer_bit( 2, false )

func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemy"):
		$Follow_Target.set_target(body)

	elif body.is_in_group("Player"):
		
		$Follow_Target.set_target(body)

func _on_Area2D_body_exited(body):
	if $Follow_Target.target_node == body:
		$Follow_Target.deselcet_target()

func _on_Healing_area_body_entered(body):
	if body.is_in_group("Enemy") :
				
		if (body.hp < body._init_hp):
			single = body
			$Follow_Target.set_target(body)
			heal = true
		else:
			heal = false
			$Follow_Target.deselcet_target()

func _on_Healing_area_body_exited(body):
	if body.is_in_group("Enemy") && single == body:
		single = null
		stop_healing()
		$Follow_Target.deselcet_target()
