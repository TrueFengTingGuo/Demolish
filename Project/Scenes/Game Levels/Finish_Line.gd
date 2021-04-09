extends Area2D

export var next_scene = ""
const Result_Scoreboard = preload("res://Scenes/Game Levels/Result_Scoreboard.tscn")

var scoreboard_displayed = false
export var time_rating = {"S":30,"A":20,"B":20,"C":20,"D":20,"E":20,"F":20}
var timer = 0
var score:int = 0

func _physics_process(delta):
	timer += delta
	


func scoring_on_timer():
	
	var pervious_rating = 0;
	for time_rule in time_rating:
		if time_rating[time_rule] < timer:
			var result = pervious_rating - timer
			
			if result > 0:
				score+= result
			return score
		else:
			score += 2000
			pervious_rating = int(time_rating[time_rule] )
			
func scoring_on_coin(player):
	score += player.coins * 250
	
func _on_Finish_Line_body_entered(body):
	if body.is_in_group("Player") and !scoreboard_displayed:
		scoreboard_displayed = true
		scoring_on_timer()
		scoring_on_coin(body)	
		
		var scoreboard = Result_Scoreboard.instance()	
		scoreboard.set_info(score,timer ,body.coins,next_scene)


		get_parent().add_child(scoreboard)
		
