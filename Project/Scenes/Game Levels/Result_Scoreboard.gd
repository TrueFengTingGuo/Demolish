extends CanvasLayer

export var rating_min = {"S":22000,"A":16000,"B":11000,"C":7000,"D":4000,"E":2000,"F":0};
var score:float = 0
var time:float = 0
var coin = 0
var next_scene = ""

var score_need_to_reach = 0
var time_need_to_reach = 0
var coin_need_to_reach = 0

var displayed_score:float = 0
var displayed_time:float= 0
var displayed_coin:float = 0

var current_rating = "F"
export var counting_score_speed = 1 #each frame will decrease the offset by the amount
export var counting_coin_speed = 3
export var counting_time_speed = 2
var counting_start = true


func _process(delta):

	if coin_need_to_reach > ceil(displayed_coin):	
			
		displayed_coin += coin * counting_coin_speed * delta
		coin -= coin *counting_coin_speed * delta	
		$VBoxContainer/Coin.text = "You earned   " + str(ceil(displayed_coin))	+ " coins"
			
	elif time_need_to_reach > ceil(displayed_time):	
		print(time_need_to_reach,displayed_time)
		displayed_time += time* counting_time_speed * delta
		time -= counting_time_speed * delta	
		$VBoxContainer/Time.text =  "You Used   " + str(stepify(displayed_time, 0.01)) + " seconds"
			
	elif score_need_to_reach > ceil(displayed_score):
		
		displayed_score += score*  counting_score_speed * delta
		score -=  score*  counting_score_speed * delta	
		$VBoxContainer/Score.text = "Final Score   " + str(ceil(displayed_score))
		
		for rating in rating_min:
			if displayed_score > rating_min[rating] and rating_min[rating] >rating_min[current_rating]:
				$Score_Rating.text = rating
				current_rating = rating
				
	else:
		if displayed_score == 0:
			$VBoxContainer/Score.set("custom_colors/font_color", Color(1,0,0))
		else:
			$VBoxContainer/Score.set("custom_colors/font_color", Color(0,1,0))
		if $Timer.is_stopped():
				$Timer.start()
			
	
		
		

func set_info(new_score,new_time ,new_coin,new_next_scene):
	score = new_score
	time = new_time
	coin = new_coin
	next_scene = new_next_scene

	score_need_to_reach = score
	time_need_to_reach = time
	coin_need_to_reach = coin
	print(score_need_to_reach)
func next_level():
	get_tree().change_scene(next_scene)


func _on_Timer_timeout():
	next_level()
