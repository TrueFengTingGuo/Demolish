# code is based on https://www.youtube.com/watch?v=Wzrw6_KDMl4


extends Node2D

onready var links = $Links		# A slightly easier reference to the links
var direction := Vector2(0,0)	# The direction in which the chain was shot
var tip := Vector2(0,0)			# The global position the tip should be in
								# We use an extra var for this, because the chain is 
								# connected to the player and thus all .position
								# properties would get messed with when the player
								# moves.

const SPEED = 10	# The speed with which the chain moves
const LINK_LENGTH = 200


var impulse_force = true
var flying = false	# Whether the chain is moving through the air
var hooked = false	# Whether the chain has connected to a wall
var reload = false
var player_dir = Vector2(0,0)
var hooked_enemy = false
var enemy_enity

# shoot() shoots the chain in a given direction
func shoot(dir: Vector2, player_location:Vector2) -> void:
	direction = dir.normalized()	
	flying = true					
	tip = self.global_position # reset the position to player position
	player_dir = player_location

# release() the chain
func release() -> void:
	
	# Not flying 	
	flying = false	
	
	# Not attached 
	hooked = false	
	reload = true
	hooked_enemy = false
	enemy_enity = null
	impulse_force = true
	
func _process(_delta: float) -> void:
	
	#if the hook is flying or hook to something
	self.visible = flying or hooked	
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
		
		var collision = $Tip.move_and_collide(direction * SPEED)
		
		if collision:	
			var collider = collision.get_collider()
			hooked = false
			
		
			if collider.is_in_group('Wall'):
				hooked = true	# Got something!
				flying = false	# Not flying anymore	
			elif collider.is_in_group('Enemy'):# if hook collide with a enemy
				
				hooked = true	# Got something!
				flying = true	# Not flying anymore
				hooked_enemy = true
				enemy_enity = collider
				$Tip.set_collision_mask_bit( 2, false )
				

		if to_local(tip).length() > LINK_LENGTH:
			release()
	
	if enemy_enity != null:
		$Tip.global_position = enemy_enity.global_position

		if impulse_force:
			var pull_dir = -2 * player_dir.direction_to(tip) *player_dir.distance_to(tip)
			impulse_force = false
			enemy_enity.on_grabed( pull_dir)
			
	else:
		$Tip.set_collision_mask_bit( 2, true )
		
	tip = $Tip.global_position
