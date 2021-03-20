# code is based on https://www.youtube.com/watch?v=Wzrw6_KDMl4


extends Node2D

onready var links = $Links		# A slightly easier reference to the links
var direction := Vector2(0,0)	# The direction in which the chain was shot
var tip := Vector2(0,0)			# The global position the tip should be in
								# We use an extra var for this, because the chain is 
								# connected to the player and thus all .position
								# properties would get messed with when the player
								# moves.
export (int, 0, 500) var push = 2
const SPEED = 700	# The speed with which the chain moves
const LINK_LENGTH = 150


var impulse_force = true
var flying = false	# Whether the chain is moving through the air
var hooked = false	# Whether the chain has connected to a wall
var reload = false
var player_dir = Vector2(0,0)
var player_position = Vector2(0,0)
var hooked_enemy = false
var hooked_cargo = false
var grabbed_collision = null
var collision_spot

# shoot() shoots the chain in a given direction
func shoot(dir: Vector2, player_location:Vector2) -> void:
	
	if reload or flying or hooked:
		return

	direction = dir.normalized()
	flying = true					
	tip = player_location # reset the position to player position
	player_dir = player_location
	$Tip/CollisionShape2D.disabled = false
	grabbed_collision = null
	
# release() the chain
func release() -> void:

	impulse_force = true
	flying = false	# Whether the chain is moving through the air
	hooked = false	# Whether the chain has connected to a wall
	reload = true
	hooked_enemy = false
	hooked_cargo = false
	player_dir = Vector2(0,0)
	player_position = Vector2(0,0)
	grabbed_collision = null
	collision_spot = null
	$Tip/CollisionShape2D.disabled = true
	
func reset()-> void:
		
	impulse_force = true
	flying = false	# Whether the chain is moving through the air
	hooked = false	# Whether the chain has connected to a wall
	reload = false
	hooked_enemy = false
	hooked_cargo = false
	grabbed_collision = null
	collision_spot = null
	

	$Tip/CollisionShape2D.disabled = true
	
func _process(_delta: float) -> void:
	
	#if the hook is flying or hook to something
	self.visible = flying or hooked or reload
	if not self.visible:
		return

	#working in the location position
	var tip_loc = to_local(tip)
	
	links.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	$Tip.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	links.position = tip_loc
	links.region_rect.size.y = tip_loc.length()		


func _physics_process(_delta: float) -> void:
	$Tip.global_position = tip	
		
	if flying:
		
		$Tip.move_and_slide(direction * SPEED, Vector2.UP,
					false, 4, PI/4, false)
		
		if !hooked:
			for index in $Tip.get_slide_count():
				var collision = $Tip.get_slide_collision(index)
				hooked = true	# Got something!
				if collision.collider.is_in_group("Cargo"):

					hooked_cargo = true
					grabbed_collision = collision
					collision_spot = $Tip.global_position - collision.collider.global_position 
					#$Tip.set_collision_mask_bit( 6, false )
					
				elif collision.collider.is_in_group('Wall'):
					flying = false	# Not flying anymore
					collision_spot = $Tip.global_position - collision.collider.global_position
				elif collision.collider.is_in_group('Enemy'):# if hook collide with a enemy

					hooked_enemy = true
					grabbed_collision = collision
					collision_spot = $Tip.global_position - collision.collider.global_position
					

		if (to_local(tip).length() > LINK_LENGTH):
			release()
				
		if hooked:
			$Tip/CollisionShape2D.disabled = true
			if grabbed_collision != null:
							
				$Tip.global_position = grabbed_collision.collider.global_position + collision_spot
				
				if impulse_force:
					var pull_dir = -200 * player_dir.direction_to(tip)
					impulse_force = false
					if grabbed_collision.collider.is_in_group('Enemy'):
						grabbed_collision.collider.on_grabed(pull_dir)
					elif grabbed_collision.collider.is_in_group('Cargo'):
						grabbed_collision.collider.on_grabed(pull_dir)
					

		
		
		tip = $Tip.global_position
		
	elif reload:
		
		$Tip/CollisionShape2D.disabled = true
		direction = $Tip.global_position.direction_to(player_position).normalized()
		$Tip.move_and_slide(direction * SPEED, Vector2.UP)
		tip = $Tip.global_position
		if $Tip.global_position.distance_to(player_position) < 10:
			reset()
		
