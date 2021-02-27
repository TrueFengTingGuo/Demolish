extends Node


var target_node

var react_time = 40
var dircetion = 1
var next_direction = 0
var next_direction_time = 0
var target_self_dist_limit = 30



var jump = 0
var next_jump = 0
var next_jump_time = 0
var target_self_jump_dist_limit = 120


var found_target = false



func _ready():
	pass


func set_next_dircetion(new_dircetion):
	if(next_direction != new_dircetion):
		next_direction = new_dircetion
		next_direction_time = OS.get_ticks_msec() + react_time

func set_next_jump(new_jump):
	if(next_jump != new_jump):
		next_jump = new_jump
		next_jump_time = OS.get_ticks_msec() + react_time
		
#called when it is folling a object
func follow_the_object(var self_global_position):
	if found_target:
		
		var target_position = target_node.global_position
		var target_self_distance_x = abs(target_position.x - self_global_position.x)
		var target_self_distance_y = abs(target_position.y - self_global_position.y)

		#horizontal movement
		if target_position.direction_to(self_global_position).x > 0 and target_self_distance_x > target_self_dist_limit :

			set_next_dircetion(-1)
			
			if  $Wall_detect_right.is_colliding():
				set_next_jump(1)
			else:
				set_next_jump(0)
		elif target_position.direction_to(self_global_position).x < 0 and target_self_distance_x > target_self_dist_limit: 

			set_next_dircetion(1)
			if  $Wall_detect_right.is_colliding():
				set_next_jump(1)
			else:
				set_next_jump(0)
		else:
			set_next_dircetion(0)
			
		# or $Wall_detect_right.is_colliding()
		#veritcal movement
		#print( target_self_distance_y)
		
		"""
		if target_position.direction_to(self_global_position).y > 0 and target_self_distance_y > target_self_jump_dist_limit : 
			set_next_jump(1)
		elif target_position.direction_to(self_global_position).y < 0 and target_self_distance_y > target_self_jump_dist_limit : 
			set_next_jump(-1)
		else:
			set_next_jump(0)
		"""
	else:
		set_next_dircetion(0)
		set_next_jump(0)

	if OS.get_ticks_msec() > next_direction_time:
		dircetion = next_direction
	
	if OS.get_ticks_msec() > next_jump_time:
		jump = next_jump
	



func set_target(body):
		target_node = body
		found_target = true
func deselcet_target():
		target_node = null
		found_target = false
		
