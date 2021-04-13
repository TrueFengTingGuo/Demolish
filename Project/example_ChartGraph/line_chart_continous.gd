extends Control


onready var chart_graph = get_node("CGLine")
var rng = RandomNumberGenerator.new()
var x = 0

var old_trail_info = 0
var new_trail_info = 0


var new_action_value_info = 0
var old_action_value_info = 0


func _ready():
	chart_graph.initialize(chart_graph.LABELS_TO_SHOW.NO_LABEL,
	{Total = Color(0.7, 0.2, 0.07),	
		Rate = Color(0.58, 0.92, 0.07),	
		Action_Value_Changes =  Color(0.6, 0.1, 0.8)
	})
	chart_graph.set_labels(7)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func give_trail_info(_info:int):
	new_trail_info = _info

func give_current_action_value(_info:float):
	
	new_action_value_info += _info
	

func _on_Timer_timeout():
	
	
	var new_rate = new_trail_info - old_trail_info
	
	
	var rescale_new_action_value_info = 0.001 * (new_action_value_info - old_action_value_info)
	old_action_value_info = new_action_value_info
	rescale_new_action_value_info = clamp(rescale_new_action_value_info,-10,10)
	
	var rescale_total = new_trail_info% 20
	chart_graph.create_new_point({
			label = String(x),
			values = {
				Total = rescale_total,
			  Rate = new_rate,				
			Action_Value_Changes = rescale_new_action_value_info	
			}
		})
	
	
	if old_trail_info != new_trail_info:
		old_trail_info = new_trail_info
		
	new_action_value_info = 0
	
	x = x + 10
