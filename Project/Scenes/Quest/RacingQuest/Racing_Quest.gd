extends Node2D

export var time_to_rest = 30
var track_Points = []
var coin_spawning_point = []
signal goal_reached

var reached = false
var rest_ai = false
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.is_in_group(("Racing_Track_Point")):
			track_Points.append(child)
			
	for child in get_children():
		if child.is_in_group(("Coin_Spawning_Point")):
			coin_spawning_point.append(child)	

	refresh_coins()
	$Timer.wait_time = time_to_rest
	$Timer.start()	
	
func _physics_process(delta):
	
	$line_chart_continous.give_trail_info($SpeedRun_AI.trail_count())
	$line_chart_continous.give_current_action_value($SpeedRun_AI/Q_Table.current_action.Q_Value)
	
	if reached == true:
		$SpeedRun_AI.global_position = self.global_position
		$SpeedRun_AI.goal_reached = true
		refresh_coins()
		reached = false		
		#reset the countdown for reseting ai position
		$Timer.start()	
		
	if track_Points.size() > 0:
		$SpeedRun_AI.goal = [track_Points[0].global_position.x,track_Points[0].global_position.y]

func refresh_coins():
	
	for child in get_children():
		if child.is_in_group(("Coin")):
			child.queue_free()
		
	for point in coin_spawning_point:
		point.spawn_coin()


func _on_Timer_timeout():
	refresh_coins()
	$SpeedRun_AI.global_position = self.global_position
	$SpeedRun_AI.reset_ai = true	
	$Timer.start()	
