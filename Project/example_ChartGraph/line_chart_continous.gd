extends Control


onready var chart_graph = get_node("CGLine")
var rng = RandomNumberGenerator.new()
var x = 0
var old_info = 0
var new_info = 0
func _ready():
	chart_graph.initialize(chart_graph.LABELS_TO_SHOW.NO_LABEL,
	{
		Rate = Color(0.58, 0.92, 0.07)
	})
	chart_graph.set_labels(7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func give_new_info(_info:int):
	new_info = _info
	
func _on_Timer_timeout():
	
	
	var new_rate = new_info - old_info
	
	chart_graph.create_new_point({
			label = String(x),
			values = {
			  Rate = new_rate
			}
		})
	if old_info != new_info:
		old_info = new_info
	x = x + 10
