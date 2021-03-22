#Credit for making a platformer AI https://www.youtube.com/watch?v=WXC8eBCEbho


extends "res://Scenes/Enemies/Enemy.gd"


var heal = false
var healing = false
var running = true
var is_hurt = false
var single = null

func _ready():
	hp = _init_hp
	SPEED = 10
	animation_state_machine =$AnimationTree.get("parameters/playback")
	
func _physics_process(delta):
	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -VELOCITY_X_LIMIT, VELOCITY_X_LIMIT)
	
	if is_on_ceiling():
		velocity.y = 0
	
	#change the direction of the sprite
	fliping()
	
	if hurt:
		var player = is_player_nearby()
		if player != null:	
			$Follow_Target.set_target(player)
		healing = false
		process_hurt()
		
	else:
		if is_on_floor():
			var single =  is_team_wound_nearby()
			if single: 
				if single.get_healing():
					heal = true
					healing = true
					$Follow_Target.set_target(single)
					animation_state_machine.travel("Healing")
				else:
					heal = false		
			else:
				heal = false	
			if healing:
				if single:
					single.get_healing(delta * 2)

			else:	
				if(abs(velocity.x) > 40) and running :

					animation_state_machine.travel("Run")	
						
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
	healing = false
	heal = true

func team_ask_for_help(body):
	
	if $Follow_Target.get_target():
		if $Follow_Target.get_target().is_in_group("Enemy"):
			
			if $Follow_Target.get_target().get_healing():

				$Follow_Target.set_target(body)
			return
	$Follow_Target.set_target(body)
func _on_Effect_animation_finished():
	$Effect.visible = false

func remove_from_targetable():
	remove_from_group("Enemy")
	set_collision_layer_bit( 2, false )

func is_team_wound_nearby():
	for body in $"Animations/Healing area".get_overlapping_bodies():
		if body.is_in_group("Enemy") and body != self:
			if body.hp:
				return body
	return null

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		$Follow_Target.set_target(body)

func _on_Area2D_body_exited(body):
	if $Follow_Target.target_node == body:
		$Follow_Target.deselcet_target()



